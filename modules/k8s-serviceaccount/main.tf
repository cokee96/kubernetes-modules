resource "kubernetes_service_account_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  automount_service_account_token = var.automount_token

  dynamic "image_pull_secret" {
    for_each = var.image_pull_secrets
    content {
      name = image_pull_secret.value
    }
  }
}
