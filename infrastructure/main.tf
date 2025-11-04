

###
resource "aws_route53_zone" "mock_zone" {
  name = "app.com"
}


resource "aws_route53_record" "mock_record" {
  zone_id = aws_route53_zone.mock_zone.zone_id
  name    = "app.com"
  type    = "A"
  records = ["127.0.0.1"]
}

resource "aws_alb" "mock_alb" {
  name = "mock_alb"
  preserve_host_header = true
}

resource "aws_wafv2_web_acl" "waf_acl" {
  name  = "waf-acl"
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "allow-host-header"
    priority = 1

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        search_string = "app.com"
        field_to_match {
          single_header {
            name = "Host"
          }
        }
        text_transformation {
          priority = 0
          type     = "NONE"
        }
        positional_constraint = "EXACTLY"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "host-header-rule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "waf_acl_association" {
  resource_arn = aws_alb.mock_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn
}

