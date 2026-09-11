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

resource "aws_route_table" "numeraid_public_subnet_rt" {
  vpc_id = aws_vpc.numeraid_vpc.id


  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-public-subnet-rt"
  })
}

resource "aws_route_table" "numeraid_private_subnet_rt" {
  vpc_id = aws_vpc.numeraid_vpc.id


  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-private-subnet-rt"
  })
}

resource "aws_route_table_association" "numeraid_public_subnet_rt_associate" {
  subnet_id      = aws_subnet.numeraid_public_subnet.id
  route_table_id = aws_route_table.numeraid_public_subnet_rt.id
}

resource "aws_route_table_association" "numeraid_private_subnet_rt_associate" {
  subnet_id      = aws_subnet.numeraid_private_subnet.id
  route_table_id = aws_route_table.numeraid_private_subnet_rt.id
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.numeraid_vpc.id
  service_name      = "com.amazonaws.af-south-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.numeraid_private_subnet.id
  ]

  security_group_ids = [
    var.endpoint_security_group_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ssm-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.numeraid_vpc.id
  service_name      = "com.amazonaws.af-south-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.numeraid_private_subnet.id
  ]

  security_group_ids = [
    var.endpoint_security_group_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ssmmessages-endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.numeraid_vpc.id
  service_name      = "com.amazonaws.af-south-1.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.numeraid_private_subnet.id
  ]

  security_group_ids = [
    var.endpoint_security_group_id
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2messages-endpoint"
  }
}