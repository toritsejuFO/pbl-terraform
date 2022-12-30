# Security group for ALB, to allow acess from any where for HTTP and HTTPS traffic
resource "aws_security_group" "IAC" {
  for_each    = local.security_groups
  name        = each.value.name
  vpc_id      = var.vpc_id
  description = each.value.description

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_dest]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.value.name}"
    }
  )
}
