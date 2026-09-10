variable "name_prefix" {
  description = "Prefix applied to every resource name in this module."
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8
}

variable "subnet_id" {
  description = "Public subnet the instance is launched into."
  type        = string
}

variable "security_group_id" {
  description = "Security group attached to the instance."
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the application bucket the instance role is scoped to."
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the application bucket, shown on the landing page and used by user data."
  type        = string
}

variable "project_name" {
  description = "Project name, shown on the landing page."
  type        = string
}

variable "environment" {
  description = "Environment name, shown on the landing page."
  type        = string
}

variable "aws_region" {
  description = "AWS region, used by user data."
  type        = string
}
