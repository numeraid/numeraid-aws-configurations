variable "project_name" {
  description = "Project name used in resource naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment used in resource naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.environment)) > 0
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

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per availability zone."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2 && alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "public_subnet_cidrs must contain at least two valid IPv4 CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per availability zone."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2 && alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "private_subnet_cidrs must contain at least two valid IPv4 CIDR blocks."
  }
}

variable "availability_zones" {
  description = "Availability zones for the subnets."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.availability_zones) == 1 && alltrue([for az in var.availability_zones : length(trimspace(az)) > 0])
    error_message = "availability_zones must contain at least two non-empty availability zone names."
  }
}