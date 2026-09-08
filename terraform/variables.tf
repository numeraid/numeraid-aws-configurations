variable "aws_region" {
  type        = string
  description = "AWS region to create resources in (e.g. af-south-1)"
  default     = "af-south-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block for the single subnet in the VPC"
  default     = "10.0.1.0/24"
}

variable "default_cidr" {
  type        = string
  description = "Default route destination CIDR (usually 0.0.0.0/0)"
  default     = "0.0.0.0/0"
}