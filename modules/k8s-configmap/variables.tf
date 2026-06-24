variable "name" {
  description = "Name of the ConfigMap."
  type        = string
}

variable "namespace" {
  description = "Namespace where the ConfigMap will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the ConfigMap."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the ConfigMap."
  type        = map(string)
  default     = {}
}

variable "data" {
  description = "Key-value pairs to store in the ConfigMap."
  type        = map(string)
  default     = {}
}

variable "binary_data" {
  description = "Base64-encoded binary data to store in the ConfigMap."
  type        = map(string)
  default     = {}
}
