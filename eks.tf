############################################################
# EKS Cluster
############################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.name
  kubernetes_version = var.eks_cluster_version

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
    aws-ebs-csi-driver = {
      before_compute = true
    }
  }

  endpoint_public_access   = true
  vpc_id                   = module.vpc.vpc_id
  control_plane_subnet_ids = module.vpc.public_subnets
  subnet_ids               = module.vpc.private_subnets
  deletion_protection      = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    stable = {
      min_size       = var.eks_node_min_size
      max_size       = var.eks_node_max_size
      desired_size   = var.eks_node_desired_size
      instance_types = var.eks_node_instance_types
    }
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
    https-all = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow incoming HTTPS traffic from anywhere"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      type        = "ingress"
    }
  }

  tags = var.tags
}
