output "name" {
  description = "Name of the Secret."
  value       = kubernetes_secret_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the Secret."
  value       = kubernetes_secret_v1.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the Secret."
  value       = kubernetes_secret_v1.this.metadata[0].uid
}
