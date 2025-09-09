##############################################
# Baserow helm chart
##############################################

data "aws_secretsmanager_secret" "rds" {
  arn = module.aurora.cluster_master_user_secret[0].secret_arn
}

module "helm" {
  source  = "terraform-module/release/helm"
  version = "2.9.1"

  namespace  = "my-baserow"
  repository = "https://baserow.gitlab.io/baserow-chart/"

  app = {
    create_namespace = true
    name             = "baserow"
    description      = "baserow deployment"
    version          = "1.0.33"
    chart            = "baserow"
    replace          = true
    force_update     = true
    wait             = false
    recreate_pods    = false
    upgrade_install  = true
    deploy           = 1
  }

  values = [
    templatefile("./charts/baserow.yaml", {
      database_host     = module.aurora.cluster_endpoint,
      database_password = "henk"
      redis_host        = module.valkey.replication_group_primary_endpoint_address,
      s3_bucket_name    = module.s3_bucket.s3_bucket_id,
      s3_region_name    = var.region,
      s3_endpoint_url   = module.s3_bucket.s3_bucket_bucket_domain_name,
      eks_role_arn      = aws_iam_role.eks.arn
  })]

  depends_on = [aws_iam_role.eks, module.aurora, module.valkey, module.s3_bucket, module.eks]
}
