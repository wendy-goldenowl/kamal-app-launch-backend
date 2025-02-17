variable "name" {
    type        = string
    description = "The name of the ASG"
}

variable "asg_subnet_ids" {
    type        = list(string)
    description = "The subnet ID for the ASG"
}

variable "asg_sg_id" {
    type        = string
    description = "The security group ID for the ASG"
}

variable "asg_target_group_arn" {
    type        = string
    description = "The target group ARN for the ASG"
}

variable "asg_img_id" {
    type        = string
    description = "The image ID for the ASG"
    default    = ""
}

variable "asg_instance_type" {
    type        = string
    description = "The instance type for the ASG"
}

variable "asg_desired_capacity" {
    type        = number
    description = "The desired capacity for the ASG"
    default    = 1
}

variable "asg_max_size" {
    type        = number
    description = "The maximum size for the ASG"
    default    = 1
}

variable "asg_min_size" {
    type        = number
    description = "The minimum size for the ASG"
    default    = 1
}

variable "ssh_public_key" {
    type        = string
    description = "The SSH public key for the ASG"
}

variable "gitlab_user" {
    type        = string
    description = "The GitLab user for the ASG"
}

variable "gitlab_token" {
    type        = string
    description = "The GitLab token for the ASG"
}