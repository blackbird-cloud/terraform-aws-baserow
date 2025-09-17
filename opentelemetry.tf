##############################################
# Open telemetry helm chart
##############################################

### TODO Add k8s secret for honeycomb api key

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.2"
}

resource "helm_release" "opentelemetry" {
  name      = "opentelemetry-collector"
  namespace = "opentelemetry-collector"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.108.1"

  create_namespace = true
  replace          = true
  force_update     = true
  wait             = true
  recreate_pods    = false
  timeout          = 300
  values = [
    yamlencode({
      tolerations = local.spot_tolerations
      mode        = "daemonset"

      image = {
        repository = "otel/opentelemetry-collector"
      }

      extraEnvs = [
        {
          name = "HONEYCOMB_API_KEY"
          valueFrom = {
            secretKeyRef = {
              key  = "honeycomb-api-key"
              name = "otel-collector-secret"
            }
          }
        }
      ]

      config = {
        exporters = {
          otlp = {
            endpoint = "api.honeycomb.io:443"
            headers = {
              "x-honeycomb-team" = join("", ["$$", "{env:HONEYCOMB_API_KEY}"])
            }
          }
          "otlp/metrics" = {
            endpoint = "api.honeycomb.io:443"
            headers = {
              "x-honeycomb-dataset" = join("", ["$$", "{env:HONEYCOMB_API_KEY}"])
              "x-honeycomb-team"    = "baserow-metrics"
            }
          }
        }
        service = {
          pipelines = {
            logs = {
              receivers  = ["otlp"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["otlp"]
            }
            metrics = {
              receivers  = ["otlp"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["otlp/metrics"]
            }
            traces = {
              receivers  = ["otlp"]
              processors = ["memory_limiter", "batch"]
              exporters  = ["otlp"]
            }
          }
        }
      }
    })
  ]
}
