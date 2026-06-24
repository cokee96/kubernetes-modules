resource "kubernetes_namespace_v1" "this" {
  metadata {
    name        = var.name
    labels      = var.labels
    annotations = var.annotations
  }
}

resource "kubernetes_resource_quota_v1" "this" {
  count = var.resource_quota != null ? 1 : 0

  metadata {
    name      = "${var.name}-quota"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  spec {
    hard = {
      for k, v in {
        "pods"            = var.resource_quota.pods
        "requests.cpu"    = var.resource_quota.requests_cpu
        "requests.memory" = var.resource_quota.requests_memory
        "limits.cpu"      = var.resource_quota.limits_cpu
        "limits.memory"   = var.resource_quota.limits_memory
      } : k => v if v != null
    }
  }
}

resource "kubernetes_limit_range_v1" "this" {
  count = var.limit_range != null ? 1 : 0

  metadata {
    name      = "${var.name}-limits"
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default = {
        for k, v in {
          "cpu"    = var.limit_range.default_cpu
          "memory" = var.limit_range.default_memory
        } : k => v if v != null
      }

      default_request = {
        for k, v in {
          "cpu"    = var.limit_range.default_request_cpu
          "memory" = var.limit_range.default_request_memory
        } : k => v if v != null
      }
    }
  }
}
