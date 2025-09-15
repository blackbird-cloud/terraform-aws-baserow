# ##############################################
# # Supporting helm charts
# ##############################################

module "k8s-charts" {
  source     = "./k8s-charts"
  depends_on = [module.eks]

  tags   = var.tags
  name   = var.name
  cluster_name = module.eks.cluster_name
  region = var.region
  vpc_id = module.vpc.vpc_id

  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn       = module.eks.oidc_provider_arn

  # baserow chart config
  s3_bucket_arn   = module.s3_bucket.s3_bucket_arn
  kms_s3_arn      = aws_kms_key.s3.arn
  kms_rds_arn     = aws_kms_key.rds.arn
  kms_valkey_arn  = aws_kms_key.valkey.arn
  db_password_arn = module.aurora.cluster_master_user_secret[0].secret_arn
}
