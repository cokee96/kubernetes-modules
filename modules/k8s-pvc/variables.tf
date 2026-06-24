variable "name" {
  description = "Name of the PersistentVolumeClaim."
  type        = string
}

variable "namespace" {
  description = "Namespace where the PVC will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the PVC."
  type        = map(string)
  default     = {}
}

variable "access_modes" {
  description = "Access modes for the PVC. Valid values: ReadWriteOnce, ReadOnlyMany, ReadWriteMany."
  type        = list(string)
  default     = ["ReadWriteOnce"]
}

variable "storage_class" {
  description = "StorageClass name. When null, the cluster default StorageClass is used."
  type        = string
  default     = null
}

variable "size" {
  description = "Storage size requested, e.g. '10Gi', '500Mi'."
  type        = string
  default     = "10Gi"
}
