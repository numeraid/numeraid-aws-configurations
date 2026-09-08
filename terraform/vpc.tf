/*
  Simple VPC + public subnet setup for learning and small labs.
  This file keeps a minimal configuration: one VPC, one subnet, an
  Internet Gateway, and a route table that sends 0.0.0.0/0 to the IGW.

  These changes only add comments and tags for clarity; they do not
  change networking defaults or resource identifiers.
*/

resource "aws_vpc" "numeraid_k8s_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-vpc"
  })
}

resource "aws_internet_gateway" "numeraid_k8s_igw" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-igw"
  })
}

resource "aws_subnet" "numeraid_k8s_public_subnet" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  cidr_block = var.public_subnet_cidr

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-public-subnet"
  })
}

resource "aws_subnet" "numeraid_k8s_private_subnet" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  cidr_block = var.private_subnet_cidr

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-private-subnet"
  })
}

resource "aws_eip" "numeraid_k8s_nat_eip" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-nat-eip"
  })
}

resource "aws_nat_gateway" "numeraid_k8s_nat_gateway" {
  allocation_id = aws_eip.numeraid_k8s_nat_eip.id
  subnet_id     = aws_subnet.numeraid_k8s_public_subnet.id

  depends_on = [
    aws_internet_gateway.numeraid_k8s_igw
  ]

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-nat-gateway"
  })
}

resource "aws_route_table" "numeraid_k8s_public_route_table" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.numeraid_k8s_igw.id
  }

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-public-rt"
  })
}

resource "aws_route_table_association" "numeraid_k8s_public_subnet_association" {
  subnet_id      = aws_subnet.numeraid_k8s_public_subnet.id
  route_table_id = aws_route_table.numeraid_k8s_public_route_table.id
}

resource "aws_route_table" "numeraid_k8s_private_route_table" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.numeraid_k8s_nat_gateway.id
  }

  tags = merge(var.common_tags, {
    Name = "numeraid-k8s-private-rt"
  })
}

resource "aws_route_table_association" "numeraid_k8s_private_subnet_association" {
  subnet_id      = aws_subnet.numeraid_k8s_private_subnet.id
  route_table_id = aws_route_table.numeraid_k8s_private_route_table.id
}

/*
  Kubernetes Security Group

  Attached to:
    - Control Plane
    - Worker Nodes

  Purpose:
    - SSH access
    - Kubernetes API access
    - Node-to-node communication
    - HTTP/HTTPS ingress
    - NodePort services
*/

resource "aws_security_group" "numeraid_k8s_sg" {
  name        = "numeraid-k8s-sg"
  description = "Security group for Numeraid Kubernetes cluster"
  vpc_id      = aws_vpc.numeraid_k8s_vpc.id
  tags        = merge(var.common_tags, { Name = "numeraid-k8s-sg" })
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.ssh_cidr]
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"

  description = "SSH"
}

resource "aws_security_group_rule" "k8s_api" {
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.k8s_api_cidr]
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"

  description = "Kubernetes API Server"
}

resource "aws_security_group_rule" "kubelet" {
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.k8s_api_cidr]
  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"

  description = "Kubelet API"
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.web_cidr]
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"

  description = "HTTP"
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.web_cidr]
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"

  description = "HTTPS"
}

resource "aws_security_group_rule" "nodeport" {
  count             = var.enable_nodeport ? 1 : 0
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.nodeport_cidr]
  from_port   = 30000
  to_port     = 32767
  protocol    = "tcp"

  description = "Kubernetes NodePort Services"
}

resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.vpc_cidr]
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"

  description = "ICMP within VPC"
}

resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.numeraid_k8s_sg.id

  cidr_blocks = [var.egress_cidr]
  protocol    = "-1"

  from_port = 0
  to_port   = 0

  description = "Allow outbound traffic"
}
