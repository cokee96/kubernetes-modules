output "name" {
  description = "Name of the ServiceAccount."
  value       = kubernetes_service_account_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the ServiceAccount."
  value       = kubernetes_service_account_v1.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the ServiceAccount."
  value       = kubernetes_service_account_v1.this.metadata[0].uid
}

output "default_secret_name" {
  description = "Name of the automatically created default secret (Kubernetes < 1.24)."
  value       = try(kubernetes_service_account_v1.this.default_secret_name, null)
}
