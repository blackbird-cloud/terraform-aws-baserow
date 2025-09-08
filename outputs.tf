output "vpc_id" { value = module.vpc.vpc_id }
output "private_subnets" { value = module.vpc.private_subnets }
output "public_subnets" { value = module.vpc.public_subnets }
output "database_subnets" { value = module.vpc.database_subnets }
output "elasticache_subnets" { value = module.vpc.elasticache_subnets }

output "aurora_endpoint" { value = module.aurora.cluster_endpoint }
output "aurora_reader_endpoint" { value = module.aurora.cluster_reader_endpoint }
output "aurora_security_group_id" { value = module.aurora.security_group_id }

output "valkey_primary_endpoint" { value = module.valkey.primary_endpoint_address }

output "eks_cluster_name" { value = module.eks.cluster_name }
output "eks_cluster_endpoint" { value = module.eks.cluster_endpoint }
output "eks_cluster_oidc_issuer" { value = module.eks.cluster_oidc_issuer_url }
