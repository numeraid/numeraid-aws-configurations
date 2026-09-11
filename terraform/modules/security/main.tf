resource "aws_security_group" "numeraid_k8s_instance_sg" {
  vpc_id = var.vpc_id

  name        = "${var.project_name}-${var.environment}-k8s-instance-sg"
  description = "Security group for Kubernetes Instances"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-numeraid-k8s-instance-sg"
  })
}
