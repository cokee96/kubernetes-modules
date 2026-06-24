variable "name" {
  description = "Name of the Deployment."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Deployment will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels applied to the Deployment and pod template."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations applied to the Deployment metadata."
  type        = map(string)
  default     = {}
}

variable "pod_annotations" {
  description = "Annotations applied to the pod template (e.g. for Prometheus scraping)."
  type        = map(string)
  default     = {}
}

variable "replicas" {
  description = "Number of desired replicas. Ignored when HPA is enabled."
  type        = number
  default     = 2
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

variable "hpa" {
  description = "HPA configuration. When set, a HorizontalPodAutoscaler is created."
  type = object({
    min_replicas            = number
    max_replicas            = number
    cpu_average_utilization = optional(number, 70)
  })
  default = null
}

variable "pdb_min_available" {
  description = "Minimum available pods for PodDisruptionBudget. Accepts an integer or percentage string."
  type        = string
  default     = null
}

variable "max_surge" {
  description = "Maximum number of pods that can be created above desired replicas during a rolling update."
  type        = string
  default     = "25%"
}

variable "max_unavailable" {
  description = "Maximum number of pods that can be unavailable during a rolling update."
  type        = string
  default     = "25%"
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
