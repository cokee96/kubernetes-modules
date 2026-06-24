output "name" {
  description = "Name of the StatefulSet."
  value       = kubernetes_stateful_set_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the StatefulSet."
  value       = kubernetes_stateful_set_v1.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the StatefulSet."
  value       = kubernetes_stateful_set_v1.this.metadata[0].uid
}
