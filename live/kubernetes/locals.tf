locals {
  common_labels = merge(
    {
      "app.kubernetes.io/name"       = var.app_name
      "app.kubernetes.io/managed-by" = "terraform"
    },
    var.extra_tags
  )

  configmap_name = length(var.config_data) > 0 ? "${var.app_name}-config" : null
}
