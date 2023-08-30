terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }

  required_version = "~> 1.3"
}