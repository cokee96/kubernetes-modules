variable "name" {
  description = "Name of the NetworkPolicy."
  type        = string
}

variable "namespace" {
  description = "Namespace where the NetworkPolicy will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the NetworkPolicy."
  type        = map(string)
  default     = {}
}

variable "pod_selector" {
  description = "Label selector identifying the pods this policy applies to."
  type        = map(string)
}

variable "policy_types" {
  description = "List of policy types to enforce. Valid values: Ingress, Egress."
  type        = list(string)
  default     = ["Ingress", "Egress"]
}

variable "ingress_rules" {
  description = "Ingress rules defining allowed inbound traffic."
  type = list(object({
    from_pod_selector       = optional(map(string))
    from_namespace_selector = optional(map(string))
    ports = list(object({
      port     = number
      protocol = optional(string, "TCP")
    }))
  }))
  default = []
}

variable "egress_rules" {
  description = "Egress rules defining allowed outbound traffic."
  type = list(object({
    from_pod_selector       = optional(map(string))
    from_namespace_selector = optional(map(string))
    ports = list(object({
      port     = number
      protocol = optional(string, "TCP")
    }))
  }))
  default = []
}
