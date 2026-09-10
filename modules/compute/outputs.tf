output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.web.id
}

output "private_ip" {
  description = "Private IP of the EC2 instance."
  value       = aws_instance.web.private_ip
}

output "elastic_ip" {
  description = "Elastic IP address associated with the instance."
  value       = aws_eip.web.public_ip
}

output "elastic_ip_allocation_id" {
  description = "Allocation ID of the Elastic IP."
  value       = aws_eip.web.id
}

output "iam_role_name" {
  description = "Name of the IAM role assumed by the instance."
  value       = aws_iam_role.ec2.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role assumed by the instance."
  value       = aws_iam_role.ec2.arn
}

output "instance_profile_name" {
  description = "Name of the instance profile attached to the instance."
  value       = aws_iam_instance_profile.ec2.name
}
