variable "name" {
    description = "The name of the load balancer"
    type        = string
}
variable "lb_sg_id" {
    description = "The security group id for the load balancer"
}

variable "lb_subnet_id" {
    description = "The subnet id for the load balancer"
    type = list(string)
}

variable "lb_vpc_id" {
    description = "The vpc id for the load balancer"
}

variable "lb_healthcheck" {
    description = "The health check for the load balancer"
    type = object({
        path                = string
        healthy_threshold   = number
        unhealthy_threshold = number
    })
}