locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "numeraid_k8s_sg" {
  name        = "${var.project_name}-${var.environment}-k8s-sg"
  description = "Kubernetes cluster security group"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-k8s-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "SSH access"
}

resource "aws_vpc_security_group_ingress_rule" "kubernetes_api" {
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 6443
  to_port     = 6443
  ip_protocol = "tcp"

  description = "Kubernetes API server"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "HTTPS"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}