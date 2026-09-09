output "bastion_public_ip" {
  description = "Public IP address of the bastion host."
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "Bastion EC2 instance ID."
  value       = aws_instance.bastion.id
}

output "bastion_security_group_id" {
  description = "Security group ID for the bastion host."
  value       = aws_security_group.bastion_sg.id
}
