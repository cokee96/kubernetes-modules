variable "name" {
  description = "Name of the Helm release."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Helm chart will be installed."
  type        = string
  default     = "default"
}

variable "create_namespace" {
  description = "When true, creates the namespace if it does not exist."
  type        = bool
  default     = true
}

variable "repository" {
  description = "URL of the Helm chart repository. Set to null for local or OCI charts."
  type        = string
  default     = null
}

variable "chart" {
  description = "Name of the Helm chart to deploy."
  type        = string
}

variable "chart_version" {
  description = "Chart version to deploy. When null, the latest version is used."
  type        = string
  default     = null
}

variable "values_files" {
  description = "List of YAML values file contents. Use file() to load from disk."
  type        = list(string)
  default     = []
}

variable "set" {
  description = "Map of individual value overrides passed via --set."
  type        = map(string)
  default     = {}
}

variable "set_sensitive" {
  description = "Map of sensitive value overrides (passwords, tokens). Values are marked sensitive."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "timeout" {
  description = "Timeout in seconds for Helm operations."
  type        = number
  default     = 300
}
