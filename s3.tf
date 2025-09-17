############################################################
# S3 Bucket
############################################################

# KMS key for S3 bucket
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags                    = var.tags
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Allow the current account to manage the KMS key.",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow the app to use the KMS key.",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : module.k8s_charts.baserow_backend_role_arn
        },
        "Action" : [
          "kms:DescribeKey",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = "${var.name}-data-${data.aws_caller_identity.current.account_id}"

  restrict_public_buckets = true
  ignore_public_acls      = true
  block_public_policy     = true
  block_public_acls       = true
  force_destroy           = false
  acl                     = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  tags = var.tags

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3.arn
      }
    }
  }
  versioning = {
    enabled = true
  }
}
