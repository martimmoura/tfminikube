terraform {

    backend "local" {
    }

    required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.0"
    }
    aws={
      source = "hashicorp/aws"
      version = "~> 6.19"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}