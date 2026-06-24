output "name" {
  description = "Name of the Service."
  value       = kubernetes_service_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the Service."
  value       = kubernetes_service_v1.this.metadata[0].namespace
}

output "cluster_ip" {
  description = "ClusterIP assigned to the Service."
  value       = kubernetes_service_v1.this.spec[0].cluster_ip
}

output "load_balancer_ip" {
  description = "LoadBalancer IP when type=LoadBalancer and an IP is assigned."
  value       = try(kubernetes_service_v1.this.status[0].load_balancer[0].ingress[0].ip, null)
}
