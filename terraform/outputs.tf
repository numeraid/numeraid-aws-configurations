output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.numeraid_k8s_vpc.id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = aws_subnet.numeraid_k8s_subnet.id
}
