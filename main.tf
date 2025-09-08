############################################################
# VPC
############################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.name
  cidr = var.vpc_cidr

  azs                 = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  public_subnets      = var.public_subnet_cidrs
  private_subnets     = var.private_subnet_cidrs
  database_subnets    = var.database_subnet_cidrs
  elasticache_subnets = var.elasticache_subnet_cidrs

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  create_elasticache_subnet_group       = true
  create_elasticache_subnet_route_table = true

  create_igw             = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  map_public_ip_on_launch = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = var.tags
}

############################################################
# Data sources
############################################################

data "aws_availability_zones" "available" {}

############################################################
# Security Groups
############################################################

resource "aws_security_group" "db" {
  name        = "${var.name}-db"
  description = "DB access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Postgres from private subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  tags = var.tags
}

resource "aws_security_group" "valkey" {
  name        = "${var.name}-valkey"
  description = "Valkey access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Valkey from private subnets"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  tags = var.tags
}

############################################################
# Aurora PostgreSQL (Serverless v2 capable cluster)
############################################################


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
      }
    ]
  })
}

############################################################
# S3 Bucket
############################################################

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket = "${var.name}-data-${data.aws_caller_identity.current.account_id}"

  restrict_public_buckets = false
  ignore_public_acls      = false
  block_public_policy     = false
  block_public_acls       = false
  force_destroy           = false

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

# KMS key for RDS encryption
data "aws_caller_identity" "current" {}

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

resource "random_password" "db" {
  length  = 20
  special = false
}

locals {
  db_password_final = coalesce(try(var.db_password, null), random_password.db.result)
}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 9.0"

  name           = "${var.name}-aurora"
  engine         = "aurora-postgresql"
  engine_mode    = "provisioned"
  engine_version = var.db_engine_version
  database_name  = replace(var.name, "-", "_")

  master_username                     = var.db_username
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
      type                     = "ingress"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.db.id
    }
  }

  // Backup settings
  backup_retention_period = 7
  backtrack_window        = 3600
  copy_tags_to_snapshot   = true


  // Encryption at rest
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn

  // Monitoring & Performance Insights
  monitoring_interval                   = 10
  enabled_cloudwatch_logs_exports       = ["postgresql"]
  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  // Maintenance settings
  apply_immediately   = true
  skip_final_snapshot = true
  deletion_protection = false
  tags                = var.tags
}

############################################################
# ElastiCache (Valkey - using redis engine)
############################################################
resource "random_password" "valkey" {
  length  = 20
  special = false
}

module "valkey" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.7"
  # Valkey settings
  replication_group_id = "${var.name}-valkey"
  engine               = "valkey" # Valkey compatible
  engine_version       = "7.2"
  node_type            = var.valkey_node_type
  num_cache_nodes      = var.valkey_num_cache_nodes
  num_cache_clusters   = 2
  # Network settings
  az_mode                      = "cross-az"
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
  parameter_group_name        = var.name
  parameter_group_family      = "valkey7"
  parameter_group_description = "${title(var.name)} parameter group"
  parameters = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]


  automatic_failover_enabled = true
  multi_az_enabled           = true

  tags = var.tags
}

############################################################
# EKS Cluster
############################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name
  kubernetes_version = var.eks_cluster_version

  endpoint_public_access   = true
  vpc_id                   = module.vpc.vpc_id
  control_plane_subnet_ids = module.vpc.public_subnets
  subnet_ids               = module.vpc.private_subnets
  deletion_protection      = true

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = var.tags
}

# ############################################################
# # Outputs convenience locals (see outputs.tf)
# ############################################################
