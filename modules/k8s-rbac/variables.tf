variable "name" {
  description = "Name of the Role or ClusterRole (and their binding)."
  type        = string
}

variable "namespace" {
  description = "Namespace for namespaced Role and RoleBinding. Ignored when cluster_wide = true."
  type        = string
  default     = "default"
}

variable "cluster_wide" {
  description = "When true, creates a ClusterRole and ClusterRoleBinding instead of namespaced resources."
  type        = bool
  default     = false
}

variable "rules" {
  description = "List of permission rules."
  type = list(object({
    api_groups = list(string)
    resources  = list(string)
    verbs      = list(string)
  }))
}

variable "subjects" {
  description = "List of subjects (users, groups, or service accounts) to bind to the role."
  type = list(object({
    kind      = string
    name      = string
    namespace = optional(string)
  }))
  default = []
}
