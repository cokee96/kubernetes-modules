resource "kubernetes_persistent_volume_claim_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  spec {
    access_modes       = var.access_modes
    storage_class_name = var.storage_class

    resources {
      requests = {
        storage = var.size
      }
    }
  }
}
