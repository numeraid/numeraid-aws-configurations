# Terraform

## Terraform flow for the Numeraid project

The root Terraform workspace in this repository is the entry point for provisioning AWS infrastructure. Terraform reads the config, resolves variables and locals, downloads the required provider, and then creates or updates the AWS resources defined in the project modules.

```text
Terraform configuration
    |
    | reads variables, locals, and module wiring
    v
AWS Provider (hashicorp/aws)
    |
    | authenticates to AWS and applies region defaults
    v
Region: af-south-1
    |
    | sets default resource tags and naming conventions
    v
Default tags:
  - Project = var.project_name
  - Environment = var.environment
  - ManagedBy = Terraform
    |
    | creates resources through reusable modules
    v
AWS resources:
  - VPC and subnets
  - Internet/NAT gateway setup
  - Security groups and ingress rules
  - EKS cluster and node groups
  - ALB / ingress points
```

### Why this flow matters

- The root module coordinates the infrastructure and keeps shared settings in one place.
- `versions.tf` pins the AWS provider version so the environment behaves consistently across machines and runs.
- `providers.tf` sets the deployment region and default tags so every created resource is traceable and organized.
- `main.tf` composes separate modules for networking, ingress, and EKS, which makes the stack easier to maintain and reason about.
