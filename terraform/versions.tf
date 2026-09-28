terraform {
  required_version = ">= 1.12.0"

  cloud {

    organization = "Numeraid"

    workspaces {
      name = "numeraid-development"
    }
  }
}
