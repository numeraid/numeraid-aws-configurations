variable "project_name" {
  description = "Project identifier used in AWS resource names and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must not be empty."
  }
}

variable "environment" {
  description = "Deployment environment used in AWS resource names and tags."
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must not be empty."
  }
}

variable "vpc_id" {
  description = "VPC ID to host the EKS cluster."
  type        = string
  nullable    = false
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the cluster worker nodes."
  type        = list(string)
  nullable    = false

  validation {
    condition     = length(var.private_subnet_ids) >= 1
    error_message = "At least one private subnet is required for EKS worker node placement."
  }
}

variable "cluster_api_access_cidrs" {
  description = "CIDR blocks allowed to reach the EKS control plane API."
  type        = list(string)
  nullable    = false
}

variable "cluster_log_types" {
  description = "EKS control plane log categories to enable."
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster."
  type        = string
  default     = "1.32"
}

variable "node_instance_type" {
  description = "EC2 instance type used for managed node groups."
  type        = string
  default     = "m6a.large"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes."
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes."
  type        = number
  default     = 4
}
