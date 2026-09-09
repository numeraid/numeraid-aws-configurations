variable "project_name" {
  description = "Project name used in naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Environment name used in naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}

variable "vpc_id" {
  description = "VPC ID where the public ingress will be created."
  type        = string
  nullable    = false
}

variable "public_subnet_ids" {
  description = "List of public subnets for the ALB."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.public_subnet_ids) >= 1
    error_message = "At least one public subnet must be provided for the ALB."
  }
}

variable "certificate_arn" {
  description = "Optional ACM certificate ARN to attach to the HTTPS listener."
  type        = string
  default     = null

  validation {
    condition     = var.certificate_arn == null || length(trimspace(var.certificate_arn)) > 0
    error_message = "certificate_arn must be null or a non-empty ARN."
  }
}

variable "allowed_ingress_cidrs" {
  description = "CIDR ranges allowed to reach the public ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_type" {
  description = "ALB target type. Use 'ip' for EKS pods behind the AWS Load Balancer Controller or 'instance' for EC2 backends."
  type        = string
  default     = "ip"

  validation {
    condition     = contains(["instance", "ip", "lambda"], var.target_type)
    error_message = "target_type must be one of: instance, ip, or lambda."
  }
}
