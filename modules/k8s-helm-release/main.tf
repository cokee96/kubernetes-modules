resource "helm_release" "this" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace

  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  values = var.values_files

  timeout         = var.timeout
  atomic          = true
  cleanup_on_fail = true
  wait            = true

  set = [
    for k, v in var.set : {
      name  = k
      value = v
    }
  ]

  set_sensitive = [
    for k, v in var.set_sensitive : {
      name  = k
      value = v
    }
  ]
}
