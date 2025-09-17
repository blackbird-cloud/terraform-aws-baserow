
############################################################
# ElastiCache (Valkey - using redis engine)
############################################################

module "valkey" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.7"

  # Valkey settings
  replication_group_id = "${var.name}-valkey"
  engine               = "valkey"
  engine_version       = "8.1"
  node_type            = var.valkey_node_type
  num_cache_clusters   = 2

  # Network settings
  automatic_failover_enabled   = true
  multi_az_enabled             = true
  create_subnet_group          = false
  subnet_group_name            = module.vpc.elasticache_subnet_group
  vpc_id                       = module.vpc.vpc_id
  security_group_ids           = [aws_security_group.valkey.id]
  preferred_availability_zones = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Encryption
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = random_password.valkey.result
  kms_key_arn                = aws_kms_key.valkey.arn

  # Parameter Group
  create_parameter_group      = true
  parameter_group_name        = "${var.name}-8"
  parameter_group_family      = "valkey8"
  parameter_group_description = "${title(var.name)} parameter group"
  parameters = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]

  tags = merge(var.tags, {
    Backup = "true"
  })
}

resource "random_password" "valkey" {
  length  = 20
  special = false
}

# KMS key for Valkey (ElastiCache)
resource "aws_kms_key" "valkey" {
  description             = "KMS key for ElastiCache/Valkey encryption"
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
          "Service" : "elasticache.amazonaws.com"
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
