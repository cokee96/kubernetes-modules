variable "name" {
  description = "Name of the ServiceAccount."
  type        = string
}

variable "namespace" {
  description = "Namespace where the ServiceAccount will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the ServiceAccount."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the ServiceAccount. Use for Workload Identity, IRSA, etc."
  type        = map(string)
  default     = {}
}

variable "automount_token" {
  description = "Whether to automatically mount a service account token. False is safer."
  type        = bool
  default     = false
}

variable "image_pull_secrets" {
  description = "List of secret names containing Docker credentials."
  type        = list(string)
  default     = []
}
