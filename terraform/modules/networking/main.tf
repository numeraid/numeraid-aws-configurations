locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc" "numeraid_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc"
  })
}

resource "aws_subnet" "numeraid_public_subnet" {
  vpc_id                  = aws_vpc.numeraid_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  })
}

resource "aws_subnet" "numeraid_private_subnet" {
  vpc_id            = aws_vpc.numeraid_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-private-subnet"
  })
}

resource "aws_internet_gateway" "numeraid_igw" {
  vpc_id = aws_vpc.numeraid_vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-igw"
  })
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.numeraid_public_subnet.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat"
  })

  depends_on = [aws_internet_gateway.numeraid_igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.numeraid_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.numeraid_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-rt"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.numeraid_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-private-rt"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.numeraid_public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.numeraid_private_subnet.id
  route_table_id = aws_route_table.private.id
}