output "etx_alb_dns_name" {
  value = aws_lb.ext_alb.dns_name
}

output "nginx_lb_target_group_arn" {
  value = aws_lb_target_group.nginx_tg.arn
}
