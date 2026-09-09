output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.numeraid_vpc.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block."
  value       = aws_vpc.numeraid_vpc.cidr_block
}
