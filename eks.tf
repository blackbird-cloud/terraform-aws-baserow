############################################################
# EKS Cluster
############################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name
  kubernetes_version = var.eks_cluster_version

  endpoint_public_access   = true
  vpc_id                   = module.vpc.vpc_id
  control_plane_subnet_ids = module.vpc.public_subnets
  subnet_ids               = module.vpc.private_subnets
  deletion_protection      = true

  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  create_node_security_group = true
  node_security_group_additional_rules = {
    ingress-all = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow incoming traffic from anywhere"
      from_port   = 1025
      to_port     = 65535
      protocol    = "tcp"
      type        = "ingress"
    }
  }

  tags = var.tags
}
