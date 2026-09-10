/*

- Terraform is the orchestration layer that reads the configuration and plans infrastructure changes.
- Terraform does not speak AWS natively, so it downloads the AWS provider plugin to translate configuration into AWS API calls.
- Pinning the provider version keeps the project consistent across local machines, CI pipelines, and future changes, reducing drift and surprise behavior.
- The Terraform CLI version is also constrained so the syntax and features used in the project remain compatible.

*/

terraform {
  required_version = ">= 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.63"
    }
  }
}
