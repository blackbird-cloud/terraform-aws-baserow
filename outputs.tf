##############################################
# VPC
##############################################
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC."
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "List of private subnet IDs."
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "List of public subnet IDs."
}

output "database_subnets" {
  value       = module.vpc.database_subnets
  description = "List of database subnet IDs."
}

output "elasticache_subnets" {
  value       = module.vpc.elasticache_subnets
  description = "List of ElastiCache subnet IDs."
}

##############################################
# Aurora
##############################################
output "aurora_endpoint" {
  value       = module.aurora.cluster_endpoint
  description = "The Aurora cluster primary endpoint."
}

output "aurora_reader_endpoint" {
  value       = module.aurora.cluster_reader_endpoint
  description = "The Aurora cluster reader endpoint."
}

output "aurora_security_group_id" {
  value       = module.aurora.security_group_id
  description = "The security group ID for the Aurora cluster."
}

output "rds_kms_key_arn" {
  value       = aws_kms_key.rds.arn
  description = "KMS key ARN used for RDS/Aurora encryption"
}

##############################################
# S3 Bucket
##############################################
output "s3_bucket_name" {
  value       = module.s3_bucket.s3_bucket_id
  description = "Naam van de S3 bucket voor Baserow data."
}
output "s3_kms_key_arn" {
  value       = aws_kms_key.s3.arn
  description = "KMS key ARN used for S3 bucket encryption."
}

##############################################
# ElastiCache
##############################################

output "valkey_kms_key_arn" {
  value       = aws_kms_key.valkey.arn
  description = "KMS key ARN used for Valkey/ElastiCache encryption."
}

output "valkey_primary_endpoint" {
  value       = module.valkey.replication_group_primary_endpoint_address
  description = "The primary endpoint address of the ElastiCache cluster."
}

##############################################
# EKS
##############################################

output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "The name of the EKS cluster."
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "The endpoint for the EKS cluster."
}
