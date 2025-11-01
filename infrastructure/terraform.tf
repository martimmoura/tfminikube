terraform {
  # backend "s3" {
  #   bucket="tf_state"
  #   key="statefile"
  #   region = "us-east-1"
  #   profile = "moto"
  # }
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.0"
    }
    aws={
      source = "hashicorp/aws"
      version = "~> 6.19"
    }
  }
}
