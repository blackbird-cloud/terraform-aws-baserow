# module "helm_keda_controller" {
#   source  = "terraform-module/release/helm"
#   version = "2.9.1"

#   namespace  = "keda"
#   repository = "https://kedacore.github.io/charts"

#   app = {
#     create_namespace = true
#     name             = "keda"
#     description      = "KEDA deployment"
#     version          = "2.17.2"
#     chart            = "keda"
#     replace          = true
#     force_update     = true
#     wait             = true
#     recreate_pods    = false
#     deploy           = 1
#     timeout          = 600
#   }

#   values = [yamlencode({
#     serviceAccount : {
#       create : true
#       name : "keda-operator"
#       annotations : {
#         "eks.amazonaws.com/role-arn" : "arn:aws:iam::471112784961:role/baserow-keda-scaler-staging"
#       }
#     }
#     metricsServer : {
#       enabled : true
#     }
#     })
#   ]
# }
