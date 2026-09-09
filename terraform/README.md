# Numeraid AWS Configuration

This root module deploys the base AWS networking foundation for the Numeraid platform.

## Resources

- VPC with DNS support enabled
- Public subnet with internet access
- Private subnet for internal workloads
- Internet gateway and public route table

## Inputs

- `aws_region`: AWS region for deployment
- `project_name`: Project name used in naming and tags
- `environment`: Deployment environment
- `vpc_cidr`: CIDR block for the VPC
- `public_subnet_cidr`: CIDR block for the public subnet
- `private_subnet_cidr`: CIDR block for the private subnet
- `availability_zone`: Availability zone for both subnets

## Outputs

- `vpc_id`
- `vpc_cidr_block`
- `public_subnet_id`
- `private_subnet_id`
- `internet_gateway_id`
- `public_route_table_id`

## Usage

```hcl
module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}
```
