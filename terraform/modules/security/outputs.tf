output "k8s_instance_sg_id" {
  description = "Kubernetes instance Security Group ID"
  value       = aws_security_group.numeraid_k8s_instance_sg.id
}
