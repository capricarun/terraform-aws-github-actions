variable "name_prefix" {
  description = "Prefix applied to every resource name in this module."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones, one per public subnet, in the same order."
  type        = list(string)
}

variable "allowed_http_cidr" {
  description = "CIDR allowed inbound on port 80."
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed inbound on port 22. Empty string creates no SSH rule."
  type        = string
  default     = ""
}
