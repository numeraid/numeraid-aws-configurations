output "security_group_id" {
  description = "Kubernetes security group ID."
  value       = aws_security_group.numeraid_k8s_sg.id
}