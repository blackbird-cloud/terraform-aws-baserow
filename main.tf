############################################################
# Data sources
############################################################

# Get available AZs in the region
data "aws_availability_zones" "available" {}

# KMS key for RDS encryption
data "aws_caller_identity" "current" {}
