# ------------------------------------------------------------------------------
# IAM role and instance profile
# The instance receives temporary credentials through the instance metadata
# service. No AWS access keys are stored on the instance.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "AllowEC2ToAssumeThisRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name        = "${var.name_prefix}-ec2-role"
  description = "Role assumed by the ${var.name_prefix} web server"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.name_prefix}-ec2-role"
  }
}

# Least privilege: list only this bucket,
# read/write only objects inside this bucket.

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid       = "ListOnlyThisBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [var.s3_bucket_arn]
  }

  statement {
    sid    = "ReadWriteObjectsInThisBucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = ["${var.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "s3_access" {
  name   = "${var.name_prefix}-s3-access"
  role   = aws_iam_role.ec2.id
  policy = data.aws_iam_policy_document.s3_access.json
}

# Allows Session Manager access without opening SSH port 22.

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.name_prefix}-ec2-profile"
  role = aws_iam_role.ec2.name

  tags = {
    Name = "${var.name_prefix}-ec2-profile"
  }
}

# ------------------------------------------------------------------------------
# EC2 web server
# ------------------------------------------------------------------------------

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [
    var.security_group_id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    project_name   = var.project_name
    environment    = var.environment
    aws_region     = var.aws_region
    s3_bucket_name = var.s3_bucket_name
  })

  # IMDSv2 only
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true

    tags = {
      Name = "${var.name_prefix}-root"
    }
  }

  tags = {
    Name = "${var.name_prefix}-web"
    Role = "web-server"
  }
}

resource "aws_eip" "web" {
  domain   = "vpc"
  instance = aws_instance.web.id

  tags = {
    Name = "${var.name_prefix}-eip"
  }

  depends_on = [aws_instance.web]
}
