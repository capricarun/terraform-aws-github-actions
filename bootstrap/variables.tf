variable "aws_region" {
  description = "Region the state bucket and lock table are created in."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Must match project_name in the main stack. Names are derived from it."
  type        = string
  default     = "project03"
}

variable "github_owner" {
  description = "Your GitHub username or organisation."
  type        = string
}

variable "github_repo" {
  description = "The repository name this role may be assumed from."
  type        = string
}

variable "create_oidc_provider" {
  description = "Set false if the GitHub OIDC provider already exists in this AWS account."
  type        = bool
  default     = true
}

variable "create_dynamodb_lock_table" {
  description = "Create a DynamoDB lock table. Only needed for older Terraform versions."
  type        = bool
  default     = true
}
