output "name" {
  description = "Name of the created namespace."
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "uid" {
  description = "UID of the created namespace."
  value       = kubernetes_namespace_v1.this.metadata[0].uid
}
