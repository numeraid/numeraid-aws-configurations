variable "aws_region" {
  description = "AWS Region where resources will be deployed."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region must not be empty."
  }
}

variable "project_name" {
  description = "Project name used in resource naming and default tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment used in resource naming and default tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  nullable    = false

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets, one per AZ."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2 && alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "public_subnet_cidrs must contain at least two valid IPv4 CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets, one per AZ."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.private_subnet_cidrs) >= 2 && alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "private_subnet_cidrs must contain at least two valid IPv4 CIDR blocks."
  }
}

variable "availability_zones" {
  description = "Availability zones used for the public and private subnets."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.availability_zones) == 1 && alltrue([for az in var.availability_zones : length(trimspace(az)) > 0])
    error_message = "availability_zones must contain at least two non-empty AZ names."
  }
}

variable "ami_id" {
  description = "Optional Ubuntu AMI ID override. When null, the latest Ubuntu 24.04 AMI is used automatically."
  type        = string
  default     = null

  validation {
    condition     = var.ami_id == null || length(trimspace(var.ami_id)) > 0
    error_message = "ami_id must be null or a non-empty AMI ID."
  }
}

variable "instance_type" {
  description = "EC2 instance type used for control-plane and worker nodes."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.instance_type)) > 0
    error_message = "instance_type must not be empty."
  }
}

variable "admin_public_cidrs" {
  description = "CIDR ranges allowed to reach the EKS control plane API. Keep this to your real public IPs or VPN ranges; do not use placeholder CIDRs."
  type        = list(string)
  default     = []
}

variable "public_ingress_cidrs" {
  description = "CIDR ranges allowed to reach the public ALB. Default is internet-facing access for app entry."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_certificate_arn" {
  description = "Optional ACM certificate ARN for the public ALB HTTPS listener. Leave null for HTTP-only ingress."
  type        = string
  default     = null

  validation {
    condition     = var.alb_certificate_arn == null || length(trimspace(var.alb_certificate_arn)) > 0
    error_message = "alb_certificate_arn must be null or a non-empty ACM certificate ARN."
  }
}

variable "enable_eks" {
  description = "Whether to deploy the EKS module using the existing VPC and private subnet layout."
  type        = bool
  default     = true
}