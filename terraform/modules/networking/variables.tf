variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the Public Subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the Private Subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for subnets."
  type        = string
}