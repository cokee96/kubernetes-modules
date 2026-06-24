resource "kubernetes_network_policy_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  spec {
    pod_selector {
      match_labels = var.pod_selector
    }

    policy_types = var.policy_types

    dynamic "ingress" {
      for_each = var.ingress_rules
      content {
        dynamic "from" {
          for_each = (
            ingress.value.from_pod_selector != null ||
            ingress.value.from_namespace_selector != null
          ) ? [1] : []
          content {
            dynamic "pod_selector" {
              for_each = ingress.value.from_pod_selector != null ? [1] : []
              content {
                match_labels = ingress.value.from_pod_selector
              }
            }

            dynamic "namespace_selector" {
              for_each = ingress.value.from_namespace_selector != null ? [1] : []
              content {
                match_labels = ingress.value.from_namespace_selector
              }
            }
          }
        }

        dynamic "ports" {
          for_each = ingress.value.ports
          content {
            port     = tostring(ports.value.port)
            protocol = ports.value.protocol
          }
        }
      }
    }

    dynamic "egress" {
      for_each = var.egress_rules
      content {
        dynamic "to" {
          for_each = (
            egress.value.from_pod_selector != null ||
            egress.value.from_namespace_selector != null
          ) ? [1] : []
          content {
            dynamic "pod_selector" {
              for_each = egress.value.from_pod_selector != null ? [1] : []
              content {
                match_labels = egress.value.from_pod_selector
              }
            }

            dynamic "namespace_selector" {
              for_each = egress.value.from_namespace_selector != null ? [1] : []
              content {
                match_labels = egress.value.from_namespace_selector
              }
            }
          }
        }

        dynamic "ports" {
          for_each = egress.value.ports
          content {
            port     = tostring(ports.value.port)
            protocol = ports.value.protocol
          }
        }
      }
    }
  }
}
