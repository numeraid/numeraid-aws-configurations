output "vpc_id" {
  description = "The VPC ID created by the networking module."
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block created by the networking module."
  value       = module.networking.vpc_cidr_block
}

output "public_subnet_id" {
  description = "The public subnet ID created by the networking module."
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "The private subnet ID created by the networking module."
  value       = module.networking.private_subnet_id
}

output "internet_gateway_id" {
  description = "The internet gateway ID created by the networking module."
  value       = module.networking.internet_gateway_id
}

output "public_route_table_id" {
  description = "The public route table ID created by the networking module."
  value       = module.networking.public_route_table_id
}
