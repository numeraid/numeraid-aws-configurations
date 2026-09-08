output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.numeraid_k8s_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the created public subnet"
  value       = aws_subnet.numeraid_k8s_public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the created private subnet"
  value       = aws_subnet.numeraid_k8s_private_subnet.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway (if created)"
  value       = aws_nat_gateway.numeraid_k8s_nat_gateway.id
  sensitive   = false
}

output "nat_eip_id" {
  description = "The EIP allocation ID for the NAT Gateway"
  value       = aws_eip.numeraid_k8s_nat_eip.id
}

output "security_group_id" {
  value = aws_security_group.numeraid_k8s_sg.id
}
