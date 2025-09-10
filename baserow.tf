##############################################
# Baserow helm chart
##############################################

data "aws_secretsmanager_secret" "rds" {
  arn = module.aurora.cluster_master_user_secret[0].secret_arn
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
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
    wait             = true
    recreate_pods    = false
    upgrade_install  = true
    deploy           = 1
  }

  values = [
    templatefile("./charts/baserow.yaml", {
      database_host       = module.aurora.cluster_endpoint,
      database_password   = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)["password"],
      redis_host          = module.valkey.replication_group_primary_endpoint_address,
      s3_bucket_name      = module.s3_bucket.s3_bucket_id,
      s3_region_name      = var.region,
      s3_endpoint_url     = module.s3_bucket.s3_bucket_bucket_domain_name,
      eks_role_arn        = aws_iam_role.eks.arn
      domain_name         = var.domain_name
      backend_domain_name = "api.${var.domain_name}"
      objects_domain_name = "objects.${var.domain_name}"
  })]

  depends_on = [aws_iam_role.eks, module.aurora, module.valkey, module.s3_bucket, module.eks, module.helm_alb_controller]
}
