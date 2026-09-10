/*

- This provider configures Terraform to deploy resources in the AWS region selected for the environment.
- The project currently targets the Cape Town region (`af-south-1`) to keep the deployment aligned with the regional requirements of the application.
- Every resource created by this provider inherits the shared tags defined in `locals.tf`, which keeps AWS resources easier to identify, audit, and bill.

  Tags used:
  - Project = var.project_name
  - Environment = var.environment
  - ManagedBy = Terraform

*/

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}
