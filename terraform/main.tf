data "aws_vpc" "default" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}


module "alb_security_group" {
  source = "./models/security_group"
  name   = "${var.name}-alb"
  vpc_id = data.aws_vpc.default.id
  description = "Security Group for private subnets"
  ingress_rules_with_cidr = [
    {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      ip          = "0.0.0.0/0"
    },
    {
      protocol   = "tcp"
      from_port   = 443
      to_port     = 443
      ip          = "0.0.0.0/0"
    },
    {
      protocol   = "tcp"
      from_port   = 22
      to_port     = 22
      ip          = "0.0.0.0/0"
    }
  ]
  egress_rules_with_cidr = [
    {
      protocol = "-1"
      ip       = "0.0.0.0/0"
    }
  ]
}

module "ec2_security_group" {
  source      = "./models/security_group"
  name        = "${var.name}-ec2"
  vpc_id      = data.aws_vpc.default.id
  description = "Security Group for public subnets"
  ingress_rules_with_security_group = [
    {
      protocol  = "tcp"
      from_port = 80
      to_port   = 80
      security_group_id = module.alb_security_group.id
    },
    {
      protocol  = "tcp"
      from_port = 3000
      to_port   = 3000
      security_group_id = module.alb_security_group.id
    },
    {
      protocol  = "tcp"
      from_port = 8080
      to_port   = 8080
      security_group_id = module.alb_security_group.id
    },
  ]
  ingress_rules_with_cidr = [
    {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      ip        = "0.0.0.0/0"
    },
  ]
  egress_rules_with_cidr = [
    {
      protocol = "-1"
      ip       = "0.0.0.0/0"
    }
  ]
}

module "load_balancer" {
  source = "./models/load_balancer"
  name        = var.name
  lb_sg_id    = module.alb_security_group.id
  lb_subnet_id = data.aws_subnets.default.ids
  lb_vpc_id    = data.aws_vpc.default.id
  lb_healthcheck = {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  # asg_name = module.asg.name
}

module "asg" {
  source = "./models/asg"
  name                  = var.name
  ssh_public_key        = var.ssh_public_key
  asg_instance_type     = var.instance_type
  asg_subnet_ids        = data.aws_subnets.default.ids
  asg_sg_id             = module.ec2_security_group.id
  asg_target_group_arn  = module.load_balancer.tg_arn
  gitlab_user           = var.gitlab_user
  gitlab_token          = var.gitlab_token
}