##############################################
# Supporting helm charts
##############################################

module "helm_alb_controller" {
  source  = "terraform-module/release/helm"
  version = "2.9.1"

  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"

  app = {
    create_namespace = true
    name             = "aws-load-balancer-controller"
    description      = "AWS Load Balancer Controller deployment"
    version          = "1.13.4"
    chart            = "aws-load-balancer-controller"
    replace          = true
    force_update     = true
    wait             = true
    recreate_pods    = false
    deploy           = 1
    timeout          = 600
  }

  values = [yamlencode({
    clusterName : var.name
    vpcId : module.vpc.vpc_id
    region : var.region
    serviceAccount : {
      create : true
      name : "aws-load-balancer-controller"
      annotations : {
        "eks.amazonaws.com/role-arn" : aws_iam_role.eks_alb_controller.arn
      }
    }
    controllerConfig : {
      featureGates : {
        EnableIPTargetType : true
      }
    }
    enableServiceMutatorWebhook : false
    })
  ]

  depends_on = [aws_iam_role.eks_alb_controller, module.aurora, module.valkey, module.s3_bucket, module.eks]
}
