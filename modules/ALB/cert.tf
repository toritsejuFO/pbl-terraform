# Create the certificate using a wildcard for all the domains created in toritsejufo
resource "aws_acm_certificate" "toritsejufo" {
  domain_name       = "*.toritsejufo.ml"
  validation_method = "DNS"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-Cert"
    }
  )
}

# Fetch existing hosted zone by name
data "aws_route53_zone" "toritsejufo" {
  name         = "toritsejufo.ml"
  private_zone = false
}

# Set up route 53 CNAME record on hosted zone using details provided by certificate
resource "aws_route53_record" "toritsejufo" {
  for_each = {
    for dvo in aws_acm_certificate.toritsejufo.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.toritsejufo.zone_id
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  allow_overwrite = true
}

# Validate certificate using DNS method
resource "aws_acm_certificate_validation" "toritsejufo" {
  certificate_arn         = aws_acm_certificate.toritsejufo.arn
  validation_record_fqdns = [for record in aws_route53_record.toritsejufo : record.fqdn]
}

# Create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.toritsejufo.zone_id
  name    = "tooling.toritsejufo.ml"
  type    = "A"

  alias {
    name                   = aws_lb.ext_alb.dns_name
    zone_id                = aws_lb.ext_alb.zone_id
    evaluate_target_health = true
  }
}

# Create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.toritsejufo.zone_id
  name    = "wordpress.toritsejufo.ml"
  type    = "A"

  alias {
    name                   = aws_lb.ext_alb.dns_name
    zone_id                = aws_lb.ext_alb.zone_id
    evaluate_target_health = true
  }
}
