output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.numeraid_vpc.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block."
  value       = aws_vpc.numeraid_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.numeraid_public_subnet[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.numeraid_private_subnet[*].id
}

output "public_subnet_id" {
  description = "Primary public subnet ID for compatibility."
  value       = aws_subnet.numeraid_public_subnet[0].id
}

output "private_subnet_id" {
  description = "Primary private subnet ID for compatibility."
  value       = aws_subnet.numeraid_private_subnet[0].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID."
  value       = aws_internet_gateway.numeraid_igw.id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Primary private route table ID."
  value       = aws_route_table.private[0].id
}

output "private_route_table_ids" {
  description = "Private route table IDs, one per private subnet."
  value       = aws_route_table.private[*].id
}

output "nat_gateway_id" {
  description = "Primary NAT gateway ID used for outbound access from private subnets."
  value       = aws_nat_gateway.this[0].id
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs, one per public subnet/AZ."
  value       = aws_nat_gateway.this[*].id
}

output "nat_public_ip" {
  description = "Primary NAT gateway public IP."
  value       = aws_eip.nat[0].public_ip
}