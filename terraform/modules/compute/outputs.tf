output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "instance_id" {
  value = aws_instance.numeraid_k8s_cp.id
}

output "private_ip" {
  value = aws_instance.numeraid_k8s_cp.private_ip
}

output "instance_state" {
  value = aws_instance.numeraid_k8s_cp.instance_state
}