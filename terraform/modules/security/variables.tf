variable "project_name" {
  description = "Project name used in security group naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment used in security group naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}

variable "vpc_id" {
  description = "VPC ID where the security group will be attached."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.vpc_id)) > 0
    error_message = "vpc_id must not be empty."
  }
}