output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.numeraid_vpc.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block."
  value       = aws_vpc.numeraid_vpc.cidr_block
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = aws_subnet.numeraid_public_subnet.id
}

output "private_subnet_id" {
  description = "Private subnet ID."
  value       = aws_subnet.numeraid_private_subnet.id
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
  description = "Private route table ID."
  value       = aws_route_table.private.id
}

output "nat_gateway_id" {
  description = "NAT gateway ID used for outbound access from private subnets."
  value       = aws_nat_gateway.this.id
}

output "nat_public_ip" {
  description = "Elastic IP allocated to the NAT gateway."
  value       = aws_eip.nat.public_ip
}