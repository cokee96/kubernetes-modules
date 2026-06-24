output "namespace" {
  description = "Namespace where the application was deployed."
  value       = module.namespace.name
}

output "service_cluster_ip" {
  description = "ClusterIP of the application Service."
  value       = module.service.cluster_ip
}

output "ingress_hostname" {
  description = "Hostname configured on the Ingress rule."
  value       = var.ingress_enabled ? var.ingress_host : null
}

output "deployment_name" {
  description = "Name of the Deployment."
  value       = module.deployment.name
}

output "hpa_name" {
  description = "Name of the HorizontalPodAutoscaler."
  value       = module.hpa.name
}
