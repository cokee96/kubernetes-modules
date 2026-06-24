output "name" {
  description = "Name of the NetworkPolicy."
  value       = kubernetes_network_policy_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the NetworkPolicy."
  value       = kubernetes_network_policy_v1.this.metadata[0].namespace
}
