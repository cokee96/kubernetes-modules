output "name" {
  description = "Name of the Ingress."
  value       = kubernetes_ingress_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the Ingress."
  value       = kubernetes_ingress_v1.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the Ingress."
  value       = kubernetes_ingress_v1.this.metadata[0].uid
}
