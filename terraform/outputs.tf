output "vpc_id" {
  description = "The VPC ID created by the networking module."
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block created by the networking module."
  value       = module.networking.vpc_cidr_block
}

output "public_subnet_id" {
  description = "The primary public subnet ID created by the networking module."
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "The primary private subnet ID created by the networking module."
  value       = module.networking.private_subnet_id
}

output "instance_id" {
  value = module.compute.instance_id
}

output "private_ip" {
  value = module.compute.private_ip
}

output "instance_state" {
  value = module.compute.instance_state
}