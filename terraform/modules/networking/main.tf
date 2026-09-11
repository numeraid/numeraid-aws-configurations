resource "aws_vpc" "numeraid_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc"
  })
}

resource "aws_subnet" "numeraid_public_subnet" {
  vpc_id     = aws_vpc.numeraid_vpc.id
  cidr_block = var.public_subnet_cidr

  map_public_ip_on_launch = true

  availability_zone = var.availability_zone

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  })
}


resource "aws_subnet" "numeraid_private_subnet" {
  vpc_id     = aws_vpc.numeraid_vpc.id
  cidr_block = var.private_subnet_cidr

  availability_zone = var.availability_zone

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-private-subnet"
  })
}
