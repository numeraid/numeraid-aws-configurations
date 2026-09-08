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

  tags = {
    Name = "numeraid-k8s-vpc"
  }
}

resource "aws_internet_gateway" "numeraid_k8s_igw" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  tags = {
    Name = "numeraid-k8s-igw"
  }
}

resource "aws_subnet" "numeraid_k8s_subnet" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  cidr_block = var.subnet_cidr

  availability_zone = "${var.aws_region}a"

  map_public_ip_on_launch = true

  tags = {
    Name = "numeraid-k8s-subnet"
  }
}

resource "aws_route_table" "numeraid_k8s_route_table" {
  vpc_id = aws_vpc.numeraid_k8s_vpc.id

  route {
    cidr_block = var.default_cidr
    gateway_id = aws_internet_gateway.numeraid_k8s_igw.id
  }

  tags = {
    Name = "numeraid-k8s-rt"
  }
}

resource "aws_route_table_association" "numeraid_k8s_route_table_association" {
  subnet_id      = aws_subnet.numeraid_k8s_subnet.id
  route_table_id = aws_route_table.numeraid_k8s_route_table.id
}
