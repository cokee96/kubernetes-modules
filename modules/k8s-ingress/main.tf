resource "kubernetes_ingress_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  spec {
    ingress_class_name = var.ingress_class

    dynamic "tls" {
      for_each = var.tls
      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secret_name
      }
    }

    dynamic "rule" {
      for_each = var.rules
      content {
        host = rule.value.host

        http {
          dynamic "path" {
            for_each = rule.value.paths
            content {
              path      = path.value.path
              path_type = path.value.path_type

              backend {
                service {
                  name = path.value.service_name
                  port {
                    number = path.value.service_port
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
