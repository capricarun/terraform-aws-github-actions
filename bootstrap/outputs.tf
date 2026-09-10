output "state_bucket_name" {
  description = "Paste this into the bucket field in backend.tf."
  value       = aws_s3_bucket.tfstate.bucket
}

output "state_bucket_region" {
  description = "Paste this into the region field in backend.tf."
  value       = var.aws_region
}

output "lock_table_name" {
  description = "Only needed if you use dynamodb_table instead of use_lockfile."
  value       = try(aws_dynamodb_table.tflock[0].name, "not created")
}

output "github_actions_role_arn" {
  description = "Save this as the AWS_ROLE_TO_ASSUME secret in your GitHub repository."
  value       = aws_iam_role.github_actions.arn
}

output "backend_block" {
  description = "The exact backend.tf contents for this account."

  value = <<-EOT
terraform {
  backend "s3" {
    bucket       = "${aws_s3_bucket.tfstate.bucket}"
    key          = "${var.project_name}/terraform.tfstate"
    region       = "${var.aws_region}"
    encrypt      = true
    use_lockfile = true
  }
}
EOT
}
