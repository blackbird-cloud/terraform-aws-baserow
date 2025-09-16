variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "baserow"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project   = "baserow"
    Terraform = "true"
  }
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for the EKS cluster"
  type        = string
}

# baserow values

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for baserow to store files"
  type        = string
}

variable "kms_s3_arn" {
  description = "KMS key ARN for S3 bucket encryption"
  type        = string
}

variable "kms_rds_arn" {
  description = "KMS key ARN for RDS/Aurora encryption"
  type        = string
}

variable "kms_valkey_arn" {
  description = "KMS key ARN for ElastiCache encryption"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
