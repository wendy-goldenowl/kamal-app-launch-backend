output "tg_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

output "alb_dns_name" {
  value = aws_lb.lb.dns_name
}

output "alb_id" {
  value = aws_lb.lb.id
}