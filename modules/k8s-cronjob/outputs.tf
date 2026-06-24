output "name" {
  description = "Name of the CronJob."
  value       = kubernetes_cron_job_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the CronJob."
  value       = kubernetes_cron_job_v1.this.metadata[0].namespace
}
