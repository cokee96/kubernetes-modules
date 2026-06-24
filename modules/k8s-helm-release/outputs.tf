output "name" {
  description = "Name of the Helm release."
  value       = helm_release.this.name
}

output "namespace" {
  description = "Namespace where the Helm release is deployed."
  value       = helm_release.this.namespace
}

output "status" {
  description = "Status of the Helm release."
  value       = helm_release.this.status
}

output "metadata" {
  description = "Metadata block from the Helm release (chart name, version, app version, etc.)."
  value       = helm_release.this.metadata
}
