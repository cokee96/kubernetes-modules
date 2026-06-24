variable "name" {
  description = "Name of the Ingress."
  type        = string
}

variable "namespace" {
  description = "Namespace where the Ingress will be created."
  type        = string
  default     = "default"
}

variable "labels" {
  description = "Labels to apply to the Ingress."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations for the Ingress. Use for nginx-ingress, cert-manager, Azure App Gateway, etc."
  type        = map(string)
  default     = {}
}

variable "ingress_class" {
  description = "IngressClass name (e.g. nginx, azure/application-gateway)."
  type        = string
  default     = "nginx"
}

variable "tls" {
  description = "TLS configuration blocks."
  type = list(object({
    hosts       = list(string)
    secret_name = string
  }))
  default = []
}

variable "rules" {
  description = "Ingress routing rules."
  type = list(object({
    host = string
    paths = list(object({
      path         = string
      path_type    = string
      service_name = string
      service_port = number
    }))
  }))
}
