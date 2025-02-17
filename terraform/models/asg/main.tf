resource "aws_key_pair" "app_key" {
  key_name   = "${terraform.workspace}-${var.name}-key"
  public_key = var.ssh_public_key
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "${terraform.workspace}-${var.name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${terraform.workspace}-${var.name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}
# ASG with Launch template
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
locals {
  ec2_ami = var.asg_img_id != "" ? var.asg_img_id : data.aws_ami.ubuntu.id
}
resource "aws_launch_template" "app" {
  name_prefix   = "${terraform.workspace}-${var.name}-template"
  image_id      = local.ec2_ami
  instance_type = var.asg_instance_type
  key_name = aws_key_pair.app_key.key_name
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    GITLAB_USER = var.gitlab_user
    GITLAB_TOKEN = var.gitlab_token
  }))
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.asg_sg_id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted            = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      propagate_at_launch = true
      Name = "${terraform.workspace}-${var.name}-template"
    }
  }
  update_default_version = true
}

resource "aws_autoscaling_group" "asg" {
  # no of instances
  desired_capacity = var.asg_desired_capacity
  max_size         = var.asg_max_size
  min_size         = var.asg_min_size

  # Connect to the target group
  target_group_arns = [var.asg_target_group_arn]

  vpc_zone_identifier = var.asg_subnet_ids


  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}