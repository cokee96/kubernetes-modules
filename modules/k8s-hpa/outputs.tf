output "name" {
  description = "Name of the HorizontalPodAutoscaler."
  value       = kubernetes_horizontal_pod_autoscaler_v2.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the HorizontalPodAutoscaler."
  value       = kubernetes_horizontal_pod_autoscaler_v2.this.metadata[0].namespace
}
