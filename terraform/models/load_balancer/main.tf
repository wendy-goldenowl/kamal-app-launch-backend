resource "aws_lb" "lb" {
  name               = "${terraform.workspace}-${var.name}-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg_id]
  subnets            = var.lb_subnet_id
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${terraform.workspace}-${var.name}-lb-alb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.lb_vpc_id
  health_check {
    path                = var.lb_healthcheck.path
    healthy_threshold   = var.lb_healthcheck.healthy_threshold
    unhealthy_threshold = var.lb_healthcheck.unhealthy_threshold
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}