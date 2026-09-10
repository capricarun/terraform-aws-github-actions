data "aws_availability_zones" "available" {
  state = "available"
}

# Newest Amazon Linux 2023 image, used only when var.ami_id is empty.
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    2
  )

  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id

  bucket_name = "${var.project_name}-${var.environment}-app-${random_id.bucket_suffix.hex}"
}

# ------------------------------------------------------------------------------
# S3 application bucket
# Versioned, encrypted, and no public access
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "app" {
  bucket = local.bucket_name

  tags = {
    Name = "${local.name_prefix}-app"
  }
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------

module "networking" {
  source = "./modules/networking"

  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = local.availability_zones
  allowed_http_cidr   = var.allowed_http_cidr
  allowed_ssh_cidr    = var.allowed_ssh_cidr
}

module "compute" {
  source = "./modules/compute"

  name_prefix      = local.name_prefix
  ami_id           = local.ami_id
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size

  subnet_id = module.networking.public_subnet_ids[0]

  security_group_id = module.networking.web_security_group_id

  s3_bucket_arn  = aws_s3_bucket.app.arn
  s3_bucket_name = aws_s3_bucket.app.bucket

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}
