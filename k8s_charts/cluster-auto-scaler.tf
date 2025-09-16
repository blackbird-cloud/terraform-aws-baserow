resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.50.1"
  namespace  = "kube-system"

  values = [yamlencode({
    autoDiscovery : {
      clusterName : var.cluster_name
    },
    awsRegion : var.region,
    rbac : {
      serviceAccount : {
        create : true
        name : "cluster-autoscaler"
        annotations : {
          "eks.amazonaws.com/role-arn" : aws_iam_role.cluster_autoscaler.arn
        }
      }
    },
    image : {
      tag : "v1.33.0"
    },
    extraArgs : {
      balance-similar-node-groups : "true"
      skip-nodes-with-system-pods : "false"
    }
    })
  ]
}
