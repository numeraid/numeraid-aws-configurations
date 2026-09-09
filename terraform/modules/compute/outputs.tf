output "control_plane_id" {
  description = "Control Plane Instance ID."
  value       = aws_instance.control_plane.id
}

output "worker_node_id" {
  description = "Worker Node Instance ID."
  value       = aws_instance.worker_node.id
}

output "key_name" {
  description = "The EC2 key pair name attached to the instances."
  value       = aws_key_pair.numeraid.key_name
}

output "private_key_pem" {
  description = "Private key material used to SSH into the EC2 instances."
  value       = tls_private_key.numeraid.private_key_pem
  sensitive   = true
}

output "control_plane_private_ip" {
  description = "Private IP address of the control-plane instance."
  value       = aws_instance.control_plane.private_ip
}

output "worker_node_private_ip" {
  description = "Private IP address of the worker node instance."
  value       = aws_instance.worker_node.private_ip
}