output "vpc_id" {
  description = "ID of the VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the two public subnets."
  value       = module.networking.public_subnet_ids
}

output "security_group_id" {
  description = "ID of the web server security group."
  value       = module.networking.web_security_group_id
}

output "ec2_instance_id" {
  description = "ID of the EC2 web server instance."
  value       = module.compute.instance_id
}

output "elastic_ip" {
  description = "Elastic IP address attached to the web server."
  value       = module.compute.elastic_ip
}

output "application_url" {
  description = "Public URL of the landing page served by the EC2 instance."
  value       = "http://${module.compute.elastic_ip}"
}

output "s3_bucket_name" {
  description = "Name of the versioned, encrypted application bucket."
  value       = aws_s3_bucket.app.bucket
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the EC2 instance profile."
  value       = module.compute.iam_role_name
}

output "iam_instance_profile_name" {
  description = "Name of the EC2 instance profile."
  value       = module.compute.instance_profile_name
}
