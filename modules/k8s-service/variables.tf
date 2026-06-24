variable "name" {
  description = "Name of the Service."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Service will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the Service."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations to apply to the Service. Use for Azure internal LB, external DNS, etc."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Service type."
  type        = string
  default     = "ClusterIP"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer", "ExternalName"], var.type)
    error_message = "Service type must be one of: ClusterIP, NodePort, LoadBalancer, ExternalName."
  }
}

variable "selector" {
  description = "Label selector to match pods targeted by this Service."
  type        = map(string)
}

variable "ports" {
  description = "List of port mappings for the Service."
  type = list(object({
    name        = string
    port        = number
    target_port = number
    protocol    = optional(string, "TCP")
    node_port   = optional(number)
  }))
}

variable "headless" {
  description = "When true, sets clusterIP=None. Used for StatefulSet headless services."
  type        = bool
  default     = false
}

variable "load_balancer_ip" {
  description = "Static IP for LoadBalancer type services."
  type        = string
  default     = null
}
