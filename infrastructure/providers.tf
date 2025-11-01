provider "helm" {
  kubernetes = {
    config_path = ".kube/kubeconfig"
  }
}

provider "kubernetes" {
  config_path = ".kube/kubeconfig"
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "testing"
  secret_key                  = "testing"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    cloudfront     = "http://localhost:5000"
    iam            = "http://localhost:5000"
    s3             = "http://localhost:5000"
    waf            = "http://localhost:5000"
    wafv2          = "http://localhost:5000"
    ecr            = "http://localhost:5000"
    route53 = "http://localhost:5000"
    route53domains = "http://localhost:5000"
    route53resolver = "http://localhost:5000"

  }
}