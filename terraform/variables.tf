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

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "default_cidr" {
  type        = string
  description = "Default route destination CIDR (usually 0.0.0.0/0)"
  default     = "0.0.0.0/0"
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to apply to all resources (can be empty)"
  default     = {}
}

variable "ssh_cidr" {
  type        = string
  description = "CIDR allowed for SSH access to bastions/control plane (restrict in production)"
  default     = "0.0.0.0/0"
}

variable "web_cidr" {
  type        = string
  description = "CIDR allowed for HTTP/HTTPS ingress to public services"
  default     = "0.0.0.0/0"
}

variable "k8s_api_cidr" {
  type        = string
  description = "CIDR allowed to reach the Kubernetes API server"
  default     = "10.0.0.0/16"
}

variable "nodeport_cidr" {
  type        = string
  description = "CIDR allowed for NodePort range access (restrict in production)"
  default     = "0.0.0.0/0"
}

variable "egress_cidr" {
  type        = string
  description = "CIDR used for egress rules (default allows all outbound)"
  default     = "0.0.0.0/0"
}

variable "enable_nodeport" {
  type        = bool
  description = "Whether to allow NodePort range ingress on the security group"
  default     = true
}