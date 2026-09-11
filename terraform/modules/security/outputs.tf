output "k8s_instance_sg_id" {
  description = "Kubernetes instance Security Group ID"
  value       = aws_security_group.numeraid_k8s_instance_sg.id
}

output "vpc_endpoint_sg_id" {
  description = "VPC Endpoint Security Group ID"
  value       = aws_security_group.vpc_endpoint_sg.id
}
