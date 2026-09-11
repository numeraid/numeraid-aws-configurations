variable "aws_region" {
  description = "AWS Region where resources will be deployed."
  type        = string
  nullable    = false

  validation {
    condition     = trimspace(var.aws_region) != ""
    error_message = "aws_region must not be empty."
  }
}

variable "project_name" {
  description = "Project name used in resource naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = trimspace(var.project_name) != ""
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment used in resource naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = trimspace(var.environment) != ""
    error_message = "environment must not be empty."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "public_subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.private_subnet_cidr, 0))
    error_message = "private_subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone" {
  description = "Availability Zone for the subnets."
  type        = string
  nullable    = false

  validation {
    condition     = trimspace(var.availability_zone) != ""
    error_message = "availability_zone must not be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
