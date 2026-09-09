# Networking Module

This module creates the core network foundation for the project:

- VPC
- Public subnet
- Private subnet
- Internet gateway
- Public route table
- Route table association

## Inputs

- `project_name`: Name used for resource naming and tags
- `environment`: Environment name used for resource naming and tags
- `vpc_cidr`: CIDR block for the VPC
- `public_subnet_cidr`: CIDR block for the public subnet
- `private_subnet_cidr`: CIDR block for the private subnet
- `availability_zone`: The AZ used for both subnets

## Outputs

- `vpc_id`
- `vpc_cidr_block`
- `public_subnet_id`
- `private_subnet_id`
- `internet_gateway_id`
- `public_route_table_id`
