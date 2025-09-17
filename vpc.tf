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
