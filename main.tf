############################################################
# Data sources
############################################################

# Get available AZs in the region
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
