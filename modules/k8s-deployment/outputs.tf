output "name" {
  description = "Name of the Deployment."
  value       = kubernetes_deployment_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the Deployment."
  value       = kubernetes_deployment_v1.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the Deployment."
  value       = kubernetes_deployment_v1.this.metadata[0].uid
}
