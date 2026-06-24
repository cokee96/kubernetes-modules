output "role_name" {
  description = "Name of the Role or ClusterRole created."
  value = var.cluster_wide ? (
    length(kubernetes_cluster_role_v1.this) > 0 ? kubernetes_cluster_role_v1.this[0].metadata[0].name : null
    ) : (
    length(kubernetes_role_v1.this) > 0 ? kubernetes_role_v1.this[0].metadata[0].name : null
  )
}

output "role_binding_name" {
  description = "Name of the RoleBinding or ClusterRoleBinding created."
  value = var.cluster_wide ? (
    length(kubernetes_cluster_role_binding_v1.this) > 0 ? kubernetes_cluster_role_binding_v1.this[0].metadata[0].name : null
    ) : (
    length(kubernetes_role_binding_v1.this) > 0 ? kubernetes_role_binding_v1.this[0].metadata[0].name : null
  )
}
