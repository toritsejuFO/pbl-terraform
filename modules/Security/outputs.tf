output "ext_lb_sg" {
  value = aws_security_group.IAC["ext_alb_sg"].id
}

output "int_lb_sg" {
  value = aws_security_group.IAC["int_alb_sg"].id
}

output "bastion_sg" {
  value = aws_security_group.IAC["bastion_sg"].id
}

output "nginx_sg" {
  value = aws_security_group.IAC["nginx_sg"].id
}

output "web_sg" {
  value = aws_security_group.IAC["webserver_sg"].id
}

output "datalayer_sg" {
  value = aws_security_group.IAC["datalayer_sg"].id
}
