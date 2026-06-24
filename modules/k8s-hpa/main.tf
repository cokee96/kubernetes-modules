resource "kubernetes_horizontal_pod_autoscaler_v2" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = var.target_kind
      name        = var.target_name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.cpu_average_utilization
        }
      }
    }

    dynamic "metric" {
      for_each = var.memory_average_utilization != null ? [1] : []
      content {
        type = "Resource"
        resource {
          name = "memory"
          target {
            type                = "Utilization"
            average_utilization = var.memory_average_utilization
          }
        }
      }
    }

    behavior {
      scale_down {
        stabilization_window_seconds = var.scale_down_stabilization_seconds

        select_policy = "Min"

        policy {
          type           = "Percent"
          value          = 10
          period_seconds = 60
        }
      }

      scale_up {
        stabilization_window_seconds = 0

        select_policy = "Max"

        policy {
          type           = "Percent"
          value          = 100
          period_seconds = 15
        }

        policy {
          type           = "Pods"
          value          = 4
          period_seconds = 15
        }
      }
    }
  }
}
