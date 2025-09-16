##############################################
# Baserow helm chart
##############################################

resource "helm_release" "baserow" {
  name      = "baserow"
  namespace = "my-baserow"

  repository = "https://baserow.gitlab.io/baserow-chart/"
  chart      = "baserow"
  version    = "1.0.33"

  create_namespace = true
  description      = "AWS Load Balancer Controller deployment"
  replace          = true
  force_update     = true
  wait             = true
  recreate_pods    = false
  timeout          = 300
  values = [
    templatefile("./chart-values/baserow.yaml", {
      database_host       = module.aurora.cluster_endpoint,
      database_password   = random_password.baserow_postgres_role.result
      redis_host          = module.valkey.replication_group_primary_endpoint_address,
      redis_password      = random_password.valkey.result,
      s3_bucket_name      = module.s3_bucket.s3_bucket_id,
      s3_region_name      = var.region,
      s3_endpoint_url     = module.s3_bucket.s3_bucket_bucket_regional_domain_name,
      eks_role_arn        = module.k8s_charts.baserow_backend_role_arn,
      domain_name         = var.domain_name
      backend_domain_name = "api.${var.domain_name}"
      objects_domain_name = "objects.${var.domain_name}"
      from_email          = "info@${var.ses_identity}"
      email_smtp_host     = "email-smtp.eu-central-1.amazonaws.com"
      email_smtp_user     = aws_iam_access_key.baserow_smtp.id
      email_smtp_password = aws_iam_access_key.baserow_smtp.ses_smtp_password_v4
  })]
  depends_on = [module.k8s_charts]
}
