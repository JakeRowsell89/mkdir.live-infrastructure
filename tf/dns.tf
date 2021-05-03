resource "aws_route53_zone" "primary" {
  name = "mkdir.live"
}

resource "aws_route53_zone" "token" {
  name = "token.mkdir.live"
}

resource "aws_acm_certificate" "token" {
  domain_name       = "token.mkdir.live"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "token" {
  certificate_arn         = aws_acm_certificate.token.arn
  validation_record_fqdns = aws_route53_record.token.*.fqdn
}

resource "aws_apigatewayv2_domain_name" "token" {
  domain_name = "token.mkdir.live"
  
  depends_on = [
    aws_acm_certificate_validation.token
  ]
  domain_name_configuration {
    certificate_arn = aws_acm_certificate.token.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "token" {
  type    = "CNAME"
  zone_id = aws_route53_zone.token.zone_id
  name    = aws_apigatewayv2_domain_name.token.domain_name
  records = ["_cb2d38919e7f0f03368c79f1199fb009.zzxlnyslwt.acm-validations.aws"]
  ttl     = 60
}

// token.mkdir.live
// site.mkdir.live
// function.mkdir.live
// upload.mkdir.live (mask S3 upload URL?)