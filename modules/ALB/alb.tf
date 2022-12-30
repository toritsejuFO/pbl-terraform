# External ALB
resource "aws_lb" "ext_alb" {
  name               = "${var.name}-Ext-ALB"
  internal           = false
  load_balancer_type = var.load_balancer_type
  ip_address_type    = var.ip_address_type
  security_groups    = [var.public_sg]
  subnets            = var.public_subnets

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-Ext-ALB"
    }
  )
}

# Nginx target group to forward External ALB request to
resource "aws_lb_target_group" "nginx_tg" {
  vpc_id      = var.vpc_id
  name        = "nginx-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"

  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# HTTPS lisetner on External ALB
resource "aws_lb_listener" "nginx_listner_https" {
  load_balancer_arn = aws_lb.ext_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.toritsejufo.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}

# HTTP lisetner on External ALB to redirect traffic to https listener
resource "aws_lb_listener" "nginx_listner_http" {
  load_balancer_arn = aws_lb.ext_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Internal ALB
resource "aws_lb" "int_alb" {
  name               = "${var.name}-Int-ALB"
  internal           = false
  load_balancer_type = var.load_balancer_type
  ip_address_type    = "ipv4"
  security_groups    = [var.private_sg]
  subnets            = var.private_subnets

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-Int-ALB"
    }
  )
}

# Target group for wordpress
resource "aws_lb_target_group" "wordpress_tg" {
  name        = "wordpress-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Target group for tooling
resource "aws_lb_target_group" "tooling_tg" {
  name        = "tooling-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    interval            = 30
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.int_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.toritsejufo.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

# Listener rule for tooling target
resource "aws_lb_listener_rule" "tooling_listener" {
  listener_arn = aws_lb_listener.web_listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling_tg.arn
  }

  condition {
    host_header {
      values = ["tooling.toritsejufo.ml"]
    }
  }
}
