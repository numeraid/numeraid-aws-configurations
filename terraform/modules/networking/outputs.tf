output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.numeraid_vpc.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block."
  value       = aws_vpc.numeraid_vpc.cidr_block
}

output "public_subnet_id" {
  description = "Primary public subnet ID for compatibility."
  value       = aws_subnet.numeraid_public_subnet.id
}

output "private_subnet_id" {
  description = "Primary private subnet ID for compatibility."
  value       = aws_subnet.numeraid_private_subnet.id
}
