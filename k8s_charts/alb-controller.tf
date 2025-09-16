resource "helm_release" "helm_alb_controller" {
  name      = "aws-load-balancer-controller"
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.13.4"

  create_namespace = true
  description      = "AWS Load Balancer Controller deployment"
  replace          = true
  force_update     = true
  wait             = true
  recreate_pods    = false
  timeout          = 600
  values = [yamlencode({
    clusterName : var.name
    vpcId : var.vpc_id
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
}
