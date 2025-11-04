resource "aws_acm_certificate" "my_domain" {
  domain_name = var.domain
}

resource "aws_cloudfront_distribution" "alb_distribution" {
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ALB"

  aliases = ["app.${var.domain}"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = true

      headers = [
        "Host",
        "Origin"
      ]

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.my_domain.arn
    ssl_support_method  = "sni-only"
  }
}

data "aws_route53_zone" "domain" {
  name = var.domain
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "app.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.alb_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.alb_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}