############################################################
# EKS Cluster
############################################################
locals {
  spot_tolerations = [for taint in module.eks.eks_managed_node_groups.spot.node_group_taints : { key : taint.key, value : taint.value, effect : "NoSchedule" }]
}

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

  endpoint_public_access = false
  # endpoint_public_access_cidrs = var.whitelist_ips
  vpc_id                   = module.vpc.vpc_id
  control_plane_subnet_ids = module.vpc.public_subnets
  subnet_ids               = module.vpc.private_subnets
  deletion_protection      = true

  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    stable = {
      min_size       = var.eks_stable_node_min_size
      max_size       = var.eks_stable_node_max_size
      desired_size   = var.eks_stable_node_desired_size
      instance_types = var.eks_stable_node_instance_types
      labels = {
        Instance = "stable"
      }
      iam_role_additional_policies = {
        ssm         = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        patch       = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
        ECRReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        Cloudwatch  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        EBS         = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
    spot = {
      min_size       = var.eks_spot_node_min_size
      max_size       = var.eks_spot_node_max_size
      desired_size   = var.eks_spot_node_desired_size
      instance_types = var.eks_spot_node_instance_types
      iam_role_additional_policies = {
        ssm         = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        patch       = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
        ECRReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        Cloudwatch  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        EBS         = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
      capacity_type = "SPOT"
      taints = {
        spot = {
          key    = "spot"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
      labels = {
        Instance = "spot"
      }
    }
  }

  create_node_security_group = true

  security_group_additional_rules = {
    vpn_access = {
      description              = "VPN ingress to Kubernetes API"
      source_security_group_id = aws_security_group.client_vpn[0].id
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
    }
  }

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

  zonal_shift_config = {
    enabled = true
  }

  tags = var.tags
}
