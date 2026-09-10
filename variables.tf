variable "aws_region" {
  description = "AWS region all resources are created in."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short name prefixed to every resource name and tag."
  type        = string
  default     = "project03"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.project_name))
    error_message = "project_name must be 3-20 characters, lowercase letters, digits and hyphens only."
  }
}

variable "environment" {
  description = "Deployment environment. Becomes part of every resource name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block, for example 10.0.0.0/16."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets, one per availability zone."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs are required."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the web server. Leave empty to auto-select the newest Amazon Linux 2023 AMI in the region."
  type        = string
  default     = ""
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to reach the web server on port 80. Public by design so the landing page is reachable."
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to reach port 22. Leave empty to create no SSH rule at all (recommended: use SSM Session Manager)."
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Size of the EC2 root EBS volume in GiB."
  type        = number
  default     = 8
}
