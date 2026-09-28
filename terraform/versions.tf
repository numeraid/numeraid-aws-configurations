terraform {
  required_version = ">= 1.12.0"

  cloud {

    organization = "Numeraid"

    workspaces {
      name = "numeraid-development"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.63"
    }
  }
}
