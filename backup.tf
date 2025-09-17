module "backup" {
  source  = "blackbird-cloud/backup/aws"
  version = "~> 1.2.0"

  name               = "centralized-backup"
  kms_key_arn        = aws_kms_key.backup.arn
  create_backup_plan = true
  resource_type_opt_in_preference = {
    "Aurora" : true,
    "EBS" : true,
    "EC2" : true,
    "RDS" : true,
    "S3" : true,
  }

  selection = {
    create_default_role = true
    condition = {
      string_equals = [{
        key   = "aws:ResourceTag/Backup"
        value = "true"
      }]
    }
    resources = ["*"]
  }

  rules = [
    {
      schedule          = "cron(0 3 * * ? *)" # Every day at 03:00 UTC
      start_window      = 60
      completion_window = 120
      lifecycle = {
        delete_after = 30
      }
    }
  ]

  vault_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
        "Sid": "Allow access to backup vault",
        "Effect": "Allow",
        "Action": "backup:CopyIntoBackupVault",
        "Resource": "*",
        "Principal": "*",
        "Condition": {
          "StringEquals": {
            "aws:AccountId": "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
  ]
}
EOF
}

resource "aws_kms_key" "backup" {
  description             = "KMS key for backup encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  tags                    = var.tags
  policy = jsonencode(
    {
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
          "Sid" : "AWSBackup",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : data.aws_caller_identity.current.account_id
          },
          "Action" : "kms:*",
          "Resource" : "*"
        }
      ]
  })
}
