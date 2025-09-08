############################################################
# VPC
############################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.name
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs
  database_subnets    = var.database_subnet_cidrs
  elasticache_subnets = var.elasticache_subnet_cidrs

  create_database_subnet_group    = true
  create_elasticache_subnet_group = true

  create_igw = true
  enable_nat_gateway = true
  single_nat_gateway = true

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

############################################################
# Aurora PostgreSQL (Serverless v2 capable cluster)
############################################################

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

  name                    = "${var.name}-aurora"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned" # serverless v2 uses provisioned engine_mode
  engine_version          = var.db_engine_version
  database_name           = replace(var.name, "-", "_")
  master_username         = var.db_username
  master_password         = local.db_password_final
  manage_master_user_password = false

  instance_class          = var.db_instance_class
  instances = {
    one = {}
  }

  serverlessv2_scaling_configuration = {
    min_capacity = var.db_min_capacity
    max_capacity = var.db_max_capacity
  }

  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group

  security_group_rules = {
    ingress_from_app = {
      type                     = "ingress"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.db.id
    }
  }

  apply_immediately               = true
  skip_final_snapshot             = true
  deletion_protection             = false
  performance_insights_enabled    = true

  tags = var.tags
}

############################################################
# ElastiCache (Valkey - using redis engine)
############################################################

module "valkey" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.7"

  engine               = "valkey" # Valkey compatible
  engine_version       = "7.2"    # Choose version compatible with Valkey features
  node_type            = var.valkey_node_type
  num_cache_nodes      = var.valkey_num_cache_nodes
  parameter_group_name = null

  subnet_group_name = module.vpc.elasticache_subnet_group
  vpc_id            = module.vpc.vpc_id
  security_group_ids = [aws_security_group.valkey.id]

  automatic_failover_enabled = false
  multi_az_enabled           = false

  tags = var.tags
}

############################################################
# EKS Cluster
############################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  cluster_name    = "${var.name}-eks"
  cluster_version = var.eks_cluster_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      instance_types = var.eks_node_instance_types
      min_size       = 1
      desired_size   = var.eks_node_desired_size
      max_size       = max(var.eks_node_desired_size, 3)
      subnet_ids     = module.vpc.private_subnets
    }
  }

  tags = var.tags
}

############################################################
# Outputs convenience locals (see outputs.tf)
############################################################
