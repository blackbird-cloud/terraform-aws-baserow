provider "aws" {
  region = "eu-central-1"
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_secretsmanager_secret" "postgres_password" {
  name = module.aurora.cluster_master_user_secret[0].secret_arn
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id = data.aws_secretsmanager_secret.postgres_password.id
}

provider "postgresql" {
  host      = module.aurora.cluster_endpoint
  port      = module.aurora.cluster_port
  password  = jsondecode(data.aws_secretsmanager_secret_version.postgres_password.secret_string)["password"]
  username  = jsondecode(data.aws_secretsmanager_secret_version.postgres_password.secret_string)["username"]
  scheme    = "awspostgres"
  superuser = false
}
