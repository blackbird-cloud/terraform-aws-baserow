############################################################
# Variables
############################################################

variable "name" {
  description = "Base name/prefix for all resources"
  type        = string
  default     = "baserow"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

# variable "whitelist_ips" {
#   description = "List of CIDR blocks to whitelist for access (e.g. your office IP)"
#   type        = list(string)
#   default     = ["185.54.181.106/32", "77.250.125.134/32"]
# }

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.10.0.0/16"
}

variable "az_count" {
  description = "Number of AZs to use"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs (one per AZ)"
  type        = list(string)
  default = [
    "10.10.0.0/24",
    "10.10.1.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs (one per AZ)"
  type        = list(string)
  default = [
    "10.10.10.0/24",
    "10.10.11.0/24"
  ]
}

variable "database_subnet_cidrs" {
  description = "List of database subnet CIDRs (one per AZ)"
  type        = list(string)
  default = [
    "10.10.20.0/24",
    "10.10.21.0/24"
  ]
}

variable "elasticache_subnet_cidrs" {
  description = "List of elasticache subnet CIDRs (one per AZ)"
  type        = list(string)
  default = [
    "10.10.30.0/24",
    "10.10.31.0/24"
  ]
}

variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.33"
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.xlarge"]
}

variable "eks_node_desired_size" {
  description = "Desired node count"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum node count"
  type        = number
  default     = 2
}

variable "eks_node_max_size" {
  description = "Maximum node count"
  type        = number
  default     = 4
}

variable "db_engine_version" {
  description = "Aurora PostgreSQL engine version"
  type        = string
  default     = "17.5"
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string
  default     = "db.t4g.medium"
}

# variable "db_password" {
#   description = "Master DB password (provide via TF_VAR_db_password)"
#   type        = string
#   sensitive   = true
#   default     = null
# }

# variable "db_username" {
#   description = "Master DB username"
#   type        = string
#   default     = "baserow"
# }

variable "valkey_node_type" {
  description = "Valkey / ElastiCache node type"
  type        = string
  default     = "cache.t4g.small"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default = {
    Project   = "baserow"
    Terraform = "true"
  }
}

variable "domain_name" {
  description = "Domain name for Route53 record (e.g. example.com)"
  type        = string
  default     = "baserow-webinar.blackbird.cloud"
}

# ------------------------------
# Client VPN
# ------------------------------
variable "client_vpn_enabled" {
  description = "Whether to create the AWS Client VPN endpoint"
  type        = bool
  default     = true
}

variable "client_vpn_cidr" {
  description = "Client CIDR range for the Client VPN endpoint (must be /22 or /23 and non-overlapping)"
  type        = string
  default     = "10.250.0.0/22"
}

variable "client_vpn_log_retention_days" {
  description = "CloudWatch log retention in days for Client VPN connection logs"
  type        = number
  default     = 30
}

variable "client_vpn_sso_group_id" {
  description = "SSO group ID for Client VPN access"
  type        = string
  default     = "e3249852-c0a1-70c2-c87c-99436c0caa94"
}


# Replace with your verified domain or email
variable "ses_identity" {
  description = "SES identity (domain or email) to verify and use for sending."
  type        = string
  default     = "baserow-webinar.blackbird.cloud"
}
