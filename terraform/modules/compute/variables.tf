variable "project_name" {
  description = "Project name used in instance naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment used in instance naming and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}

variable "private_subnet_id" {
  description = "Private subnet ID where compute instances will be placed."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.private_subnet_id)) > 0
    error_message = "private_subnet_id must not be empty."
  }
}

variable "security_group_id" {
  description = "Security group ID assigned to the EC2 instances."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.security_group_id)) > 0
    error_message = "security_group_id must not be empty."
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
  description = "EC2 instance type used for the control-plane and worker nodes."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.instance_type)) > 0
    error_message = "instance_type must not be empty."
  }
}
