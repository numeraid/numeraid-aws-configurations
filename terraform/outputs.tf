output "vpc_id" {
  description = "The ID of the deployed VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs created by the VPC module."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs created by the VPC module."
  value       = module.vpc.private_subnet_ids
}

output "aws_region" {
  description = "AWS region configured for the deployment."
  value       = var.aws_region
}
