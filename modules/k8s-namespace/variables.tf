variable "name" {
  description = "Name of the namespace."
  type        = string
}

variable "labels" {
  description = "Labels to apply to the namespace."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the namespace."
  type        = map(string)
  default     = {}
}

variable "resource_quota" {
  description = "Optional ResourceQuota configuration."
  type = object({
    pods            = optional(string)
    requests_cpu    = optional(string)
    requests_memory = optional(string)
    limits_cpu      = optional(string)
    limits_memory   = optional(string)
  })
  default = null
}

variable "limit_range" {
  description = "Optional LimitRange configuration for default container limits."
  type = object({
    default_cpu            = optional(string)
    default_memory         = optional(string)
    default_request_cpu    = optional(string)
    default_request_memory = optional(string)
  })
  default = null
}
