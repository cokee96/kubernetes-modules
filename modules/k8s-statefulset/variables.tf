variable "name" {
  description = "Name of the StatefulSet."
  type        = string
}

variable "namespace" {
  description = "Namespace where the StatefulSet will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels applied to the StatefulSet and pod template."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations applied to the StatefulSet metadata."
  type        = map(string)
  default     = {}
}

variable "pod_annotations" {
  description = "Annotations applied to the pod template."
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "Number of desired replicas."
  type        = number
  default     = 2
}

variable "headless_service_name" {
  description = "Name of the headless Service governing this StatefulSet. Must exist before the StatefulSet."
  type        = string
}

variable "service_account_name" {
  description = "Name of the ServiceAccount to use for pods."
  type        = string
  default     = ""
}

variable "node_selector" {
  description = "Node selector labels for pod scheduling."
  type        = map(string)
  default     = {}
}

variable "containers" {
  description = "List of containers in the pod."
  type = list(object({
    name              = string
    image             = string
    image_pull_policy = optional(string, "IfNotPresent")
    ports = optional(list(object({
      name           = string
      container_port = number
      protocol       = optional(string, "TCP")
    })), [])
    resources = optional(object({
      requests_cpu    = optional(string)
      requests_memory = optional(string)
      limits_cpu      = optional(string)
      limits_memory   = optional(string)
    }), {})
    env = optional(list(object({
      name  = string
      value = string
    })), [])
    env_from_configmaps = optional(list(string), [])
    env_from_secrets    = optional(list(string), [])
    volume_mounts = optional(list(object({
      name       = string
      mount_path = string
      read_only  = optional(bool, false)
    })), [])
    liveness_probe = optional(object({
      type                  = string
      path                  = optional(string)
      port                  = optional(number)
      command               = optional(list(string))
      initial_delay_seconds = optional(number, 30)
      period_seconds        = optional(number, 10)
      failure_threshold     = optional(number, 3)
    }))
    readiness_probe = optional(object({
      type                  = string
      path                  = optional(string)
      port                  = optional(number)
      command               = optional(list(string))
      initial_delay_seconds = optional(number, 10)
      period_seconds        = optional(number, 10)
      failure_threshold     = optional(number, 3)
    }))
    startup_probe = optional(object({
      type                  = string
      path                  = optional(string)
      port                  = optional(number)
      command               = optional(list(string))
      initial_delay_seconds = optional(number, 0)
      period_seconds        = optional(number, 10)
      failure_threshold     = optional(number, 30)
    }))
  }))
}

variable "init_containers" {
  description = "List of init containers run before application containers."
  type = list(object({
    name              = string
    image             = string
    image_pull_policy = optional(string, "IfNotPresent")
    ports = optional(list(object({
      name           = string
      container_port = number
      protocol       = optional(string, "TCP")
    })), [])
    resources = optional(object({
      requests_cpu    = optional(string)
      requests_memory = optional(string)
      limits_cpu      = optional(string)
      limits_memory   = optional(string)
    }), {})
    env = optional(list(object({
      name  = string
      value = string
    })), [])
    env_from_configmaps = optional(list(string), [])
    env_from_secrets    = optional(list(string), [])
    volume_mounts = optional(list(object({
      name       = string
      mount_path = string
      read_only  = optional(bool, false)
    })), [])
    liveness_probe  = optional(any)
    readiness_probe = optional(any)
    startup_probe   = optional(any)
  }))
  default = []
}

variable "volumes" {
  description = "List of volumes available to containers."
  type = list(object({
    name        = string
    type        = string
    source_name = optional(string)
  }))
  default = []
}

variable "volume_claim_templates" {
  description = "PVC templates for stable per-pod storage."
  type = list(object({
    name          = string
    access_modes  = optional(list(string), ["ReadWriteOnce"])
    storage_class = optional(string)
    size          = optional(string, "10Gi")
  }))
  default = []
}

variable "pod_management_policy" {
  description = "Controls how pods are created during initial scale-up. OrderedReady or Parallel."
  type        = string
  default     = "OrderedReady"
}

variable "tolerations" {
  description = "List of tolerations for pod scheduling on tainted nodes."
  type = list(object({
    key      = string
    operator = string
    value    = optional(string)
    effect   = string
  }))
  default = []
}
