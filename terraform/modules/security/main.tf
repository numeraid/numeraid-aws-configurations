resource "aws_security_group" "numeraid_k8s_instance_sg" {
  vpc_id = var.vpc_id

  name        = "${var.project_name}-${var.environment}-k8s-instance-sg"
  description = "Security group for Kubernetes Instances"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-numeraid-k8s-instance-sg"
  })
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name   = "${var.project_name}-${var.environment}-endpoint-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
