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

output "private_route_table_id" {
  description = "The private route table ID created by the networking module."
  value       = module.networking.private_route_table_id
}

output "nat_gateway_id" {
  description = "The NAT gateway ID created by the networking module."
  value       = module.networking.nat_gateway_id
}

output "nat_public_ip" {
  description = "The NAT gateway public IP created by the networking module."
  value       = module.networking.nat_public_ip
}

output "security_group_id" {
  description = "The Kubernetes security group ID created by the security module."
  value       = module.security.security_group_id
}

output "control_plane_id" {
  description = "The control-plane instance ID created by the compute module."
  value       = module.compute.control_plane_id
}

output "worker_node_id" {
  description = "The worker node instance ID created by the compute module."
  value       = module.compute.worker_node_id
}
