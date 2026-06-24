variable "name" {
  description = "Name of the Secret."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Secret will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the Secret."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the Secret."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Type of Secret. Common values: Opaque, kubernetes.io/tls, kubernetes.io/dockerconfigjson."
  type        = string
  default     = "Opaque"
}

variable "data" {
  description = "Key-value pairs of secret data. The provider handles base64 encoding automatically."
  type        = map(string)
  sensitive   = true
}

variable "immutable" {
  description = "When true, the Secret cannot be updated after creation."
  type        = bool
  default     = false
}
