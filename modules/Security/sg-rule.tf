# security group for alb, to allow access from any where on port 80 for http traffic
resource "aws_security_group_rule" "inbound_ealb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.IAC["ext_alb_sg"].id
}

resource "aws_security_group_rule" "inbound_ealb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.IAC["ext_alb_sg"].id
}


# security group rule for bastion to allow assh access fro your local machine
resource "aws_security_group_rule" "inbound_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.IAC["bastion_sg"].id
}


# security group for nginx reverse proxy, to allow access only from the external load balancer and bastion instance
resource "aws_security_group_rule" "inbound_nginx_http" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["ext_alb_sg"].id
  security_group_id        = aws_security_group.IAC["nginx_sg"].id
}


resource "aws_security_group_rule" "inbound_nginx_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["bastion_sg"].id
  security_group_id        = aws_security_group.IAC["nginx_sg"].id
}


# security group for ialb, to have access only from nginx reverse proxy server
resource "aws_security_group_rule" "inbound_ialb_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["nginx_sg"].id
  security_group_id        = aws_security_group.IAC["int_alb_sg"].id
}


# security group for webservers, to have access only from the internal load balancer and bastion instance
resource "aws_security_group_rule" "inbound_web_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["int_alb_sg"].id
  security_group_id        = aws_security_group.IAC["webserver_sg"].id
}

resource "aws_security_group_rule" "inbound_web_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["bastion_sg"].id
  security_group_id        = aws_security_group.IAC["webserver_sg"].id
}


# security group for datalayer to alow traffic from websever on nfs and mysql port and bastion host on mysql port
resource "aws_security_group_rule" "inbound_nfs_port" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["webserver_sg"].id
  security_group_id        = aws_security_group.IAC["datalayer_sg"].id
}

resource "aws_security_group_rule" "inbound_mysql_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["bastion_sg"].id
  security_group_id        = aws_security_group.IAC["datalayer_sg"].id
}

resource "aws_security_group_rule" "inbound_mysql_webserver" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.IAC["webserver_sg"].id
  security_group_id        = aws_security_group.IAC["datalayer_sg"].id
}
