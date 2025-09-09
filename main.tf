############################################################
# Data sources
############################################################

# Get available AZs in the region
data "aws_availability_zones" "available" {}

# Get current AWS account info
data "aws_caller_identity" "current" {}
