resource "aws_vpc" "numeraid_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "numeraid_public_subnet" {
  vpc_id                  = aws_vpc.numeraid_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-subnet"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_subnet" "numeraid_private_subnet" {
  vpc_id            = aws_vpc.numeraid_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-subnet"
    Environment = var.environment
    Project     = var.project_name
  }
}