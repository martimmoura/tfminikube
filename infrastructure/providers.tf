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
  https_proxy = "http://localhost:5005"
  custom_ca_bundle            = "${path.module}/moto/ca.crt"
}

