variable "name" {
  description = "Name of the CronJob."
  type        = string
}

variable "namespace" {
  description = "Namespace where the CronJob will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the CronJob."
  type        = map(string)
  default     = {}
}

variable "schedule" {
  description = "Cron schedule expression, e.g. '0 * * * *' for every hour."
  type        = string
}

variable "concurrency_policy" {
  description = "How concurrent executions are handled."
  type        = string
  default     = "Forbid"
  validation {
    condition     = contains(["Allow", "Forbid", "Replace"], var.concurrency_policy)
    error_message = "concurrency_policy must be Allow, Forbid, or Replace."
  }
}

variable "successful_jobs_history_limit" {
  description = "Number of successful completed jobs to retain."
  type        = number
  default     = 3
}

variable "failed_jobs_history_limit" {
  description = "Number of failed completed jobs to retain."
  type        = number
  default     = 1
}

variable "restart_policy" {
  description = "Restart policy for pods in the job. OnFailure or Never."
  type        = string
  default     = "OnFailure"
}

variable "containers" {
  description = "List of containers to run in each job pod."
  type = list(object({
    name              = string
    image             = string
    image_pull_policy = optional(string, "IfNotPresent")
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
  }))
}
