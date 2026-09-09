variable "project_name" {
  description = "Project name used in resource naming and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment used in resource naming and tags."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the bastion security group will be created."
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where the bastion instance will be launched."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name to attach to the bastion instance."
  type        = string
}

variable "ami_id" {
  description = "Optional AMI ID override. When null, the latest Ubuntu 24.04 AMI is used."
  type        = string
  default     = null
}

variable "allowed_ssh_cidr" {
  description = "CIDR that is allowed to SSH to the bastion (e.g. your-public-ip/32)."
  type        = string
  default     = "0.0.0.0/0"
}
