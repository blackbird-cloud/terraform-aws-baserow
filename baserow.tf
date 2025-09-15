##############################################
# Baserow helm chart
##############################################

data "aws_secretsmanager_secret" "rds" {
  arn = module.aurora.cluster_master_user_secret[0].secret_arn
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}

resource "helm_release" "baserow" {
  name       = "baserow"
  namespace  = "my-baserow"

  repository = "https://baserow.gitlab.io/baserow-chart/"
  chart      = "baserow"
  version    = "1.0.33"

  create_namespace = true
  description      = "AWS Load Balancer Controller deployment"
  replace          = true
  force_update     = true
  wait             = true
  recreate_pods    = false
  timeout          = 600
  values = [
    templatefile("./chart-values/baserow.yaml", {
      database_host       = module.aurora.cluster_endpoint,
      database_password   = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"],
      redis_host          = module.valkey.replication_group_primary_endpoint_address,
      s3_bucket_name      = module.s3_bucket.s3_bucket_id,
      s3_region_name      = var.region,
      s3_endpoint_url     = module.s3_bucket.s3_bucket_bucket_domain_name,
      eks_role_arn        = module.k8s-charts.baserow_backend_role_arn,
      domain_name         = var.domain_name
      backend_domain_name = "api.${var.domain_name}"
      objects_domain_name = "objects.${var.domain_name}"
  })]

}