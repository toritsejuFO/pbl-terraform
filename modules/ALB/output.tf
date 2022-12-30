output "etx_alb_dns_name" {
  value       = aws_lb.ext_alb.dns_name
  description = "External load balance arn"
}

output "nginx_lb_tg_arn" {
  value       = aws_lb_target_group.nginx_tg.arn
  description = "External Load balancaer target group"
}

output "wordpress_lb_tg_arn" {
  description = "wordpress target group"
  value       = aws_lb_target_group.wordpress_tg.arn
}

output "tooling_lb_tg_arn" {
  description = "Tooling target group"
  value       = aws_lb_target_group.tooling_tg.arn
}
