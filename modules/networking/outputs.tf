output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = "ID of the internet gateway."
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets, in the order their CIDRs were supplied."
  value       = aws_subnet.public[*].id
}

output "route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.public.id
}

output "web_security_group_id" {
  description = "ID of the web server security group."
  value       = aws_security_group.web.id
}
