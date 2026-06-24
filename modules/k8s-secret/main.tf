resource "kubernetes_secret_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  type      = var.type
  data      = var.data
  immutable = var.immutable
}
