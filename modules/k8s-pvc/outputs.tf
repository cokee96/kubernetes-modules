output "name" {
  description = "Name of the PersistentVolumeClaim."
  value       = kubernetes_persistent_volume_claim_v1.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the PersistentVolumeClaim."
  value       = kubernetes_persistent_volume_claim_v1.this.metadata[0].namespace
}

output "uid" {
  description = "UID of the PersistentVolumeClaim."
  value       = kubernetes_persistent_volume_claim_v1.this.metadata[0].uid
}
