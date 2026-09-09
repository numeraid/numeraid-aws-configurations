locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "tls_private_key" "numeraid" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "numeraid" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = tls_private_key.numeraid.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "control_plane" {
  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.numeraid.key_name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-control-plane"
    Role = "control-plane"
  })
}

resource "aws_instance" "worker_node" {
  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.numeraid.key_name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-worker-node"
    Role = "worker"
  })
}

