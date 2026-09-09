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

output "public_subnet_ids" {
  description = "All public subnet IDs created by the networking module."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_id" {
  description = "The primary private subnet ID created by the networking module."
  value       = module.networking.private_subnet_id
}

output "private_subnet_ids" {
  description = "All private subnet IDs created by the networking module."
  value       = module.networking.private_subnet_ids
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

output "alb_dns_name" {
  description = "DNS name of the public ALB ingress layer."
  value       = module.ingress.load_balancer_dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the public ALB ingress layer."
  value       = module.ingress.load_balancer_zone_id
}

output "cluster_name" {
  description = "The EKS cluster name when the EKS module is enabled."
  value       = var.enable_eks ? module.eks[0].cluster_name : null
}
