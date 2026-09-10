aws_region   = "ap-south-1"
project_name = "project03"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

instance_type = "t3.micro"

# Leave empty to automatically select
# the newest Amazon Linux 2023 AMI.
ami_id = ""

allowed_http_cidr = "0.0.0.0/0"

# Empty string means no SSH rule is created.
allowed_ssh_cidr = ""

root_volume_size = 8
