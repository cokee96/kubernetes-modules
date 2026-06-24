variable "name" {
  description = "Name of the HorizontalPodAutoscaler."
  type        = string
}

variable "namespace" {
  description = "Namespace where the HPA will be created."
  type        = string
  default     = "default"
}

variable "target_name" {
  description = "Name of the target Deployment (or other scalable resource)."
  type        = string
}

variable "target_kind" {
  description = "Kind of the scale target."
  type        = string
  default     = "Deployment"
}

variable "min_replicas" {
  description = "Minimum number of replicas."
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Maximum number of replicas."
  type        = number
  default     = 10
}

variable "cpu_average_utilization" {
  description = "Target average CPU utilization percentage."
  type        = number
  default     = 70
}

variable "memory_average_utilization" {
  description = "Target average memory utilization percentage. When null, memory metric is not added."
  type        = number
  default     = null
}

variable "scale_down_stabilization_seconds" {
  description = "Stabilization window for scale-down decisions in seconds."
  type        = number
  default     = 300
}
