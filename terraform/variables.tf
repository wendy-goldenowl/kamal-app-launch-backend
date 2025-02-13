variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "default"
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "name" {
  description = "Name of the instance"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "gitlab_user" {
  description = "GitLab user"
  type        = string
}

variable "gitlab_token" {
  description = "GitLab token"
  type        = string
}