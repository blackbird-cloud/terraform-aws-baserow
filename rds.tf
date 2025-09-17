############################################################
# Aurora PostgreSQL (Serverless v2 capable cluster)
############################################################

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 9.0"

  name           = "${var.name}-aurora"
  engine         = "aurora-postgresql"
  engine_mode    = "provisioned"
  engine_version = var.db_engine_version
  # database_name  = replace(var.name, "-", "_")

  master_username                     = "master"
  manage_master_user_password         = true
  iam_database_authentication_enabled = true

  instance_class = var.db_instance_class
  instances = {
    t4g-one = {
      instance_class = var.db_instance_class
    }
    t4g-two = {
      instance_class = var.db_instance_class
    }
  }

  vpc_id                = module.vpc.vpc_id
  db_subnet_group_name  = module.vpc.database_subnet_group
  create_security_group = true
  security_group_rules = {
    ingress_from_app = {
      cidr_blocks = var.private_subnet_cidrs
    }
    vpn = {
      source_security_group_id = aws_security_group.client_vpn[0].id
    }
  }

  # Backup settings
  backup_retention_period = 7
  backtrack_window        = 3600
  copy_tags_to_snapshot   = true


  # Encryption at rest
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn

  # Monitoring & Performance Insights
  monitoring_interval                   = 10
  enabled_cloudwatch_logs_exports       = ["postgresql"]
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  # Maintenance settings
  apply_immediately   = true
  skip_final_snapshot = true
  deletion_protection = false
  tags = merge(var.tags, {
    Backup = "true"
  })
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS Aurora cluster encryption"
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
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "rds.amazonaws.com"
          },
          "Action" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource" : "*"
        }
      ]
  })
}
