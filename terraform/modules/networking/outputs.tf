output "vpc_id" {
  description = "The VPC ID."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The VPC CIDR block."
  value       = aws_vpc.main.cidr_block
}
