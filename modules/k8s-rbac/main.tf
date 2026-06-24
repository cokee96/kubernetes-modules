resource "kubernetes_role_v1" "this" {
  count = var.cluster_wide ? 0 : 1

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_cluster_role_v1" "this" {
  count = var.cluster_wide ? 1 : 0

  metadata {
    name = var.name
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding_v1" "this" {
  count = var.cluster_wide ? 0 : (length(var.subjects) > 0 ? 1 : 0)

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.this[0].metadata[0].name
  }

  dynamic "subject" {
    for_each = var.subjects
    content {
      kind      = subject.value.kind
      name      = subject.value.name
      namespace = subject.value.namespace
    }
  }
}

resource "kubernetes_cluster_role_binding_v1" "this" {
  count = var.cluster_wide ? (length(var.subjects) > 0 ? 1 : 0) : 0

  metadata {
    name = var.name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.this[0].metadata[0].name
  }

  dynamic "subject" {
    for_each = var.subjects
    content {
      kind      = subject.value.kind
      name      = subject.value.name
      namespace = subject.value.namespace
    }
  }
}
