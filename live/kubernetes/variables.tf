variable "kubeconfig_path" {
  description = "Path to kubeconfig file for local development. Leave null when running inside a pod or using AKS data source."
  type        = string
  default     = null
}

variable "namespace" {
  description = "Kubernetes namespace where the application will be deployed."
  type        = string
}

variable "app_name" {
  description = "Application name used as base for resource names and labels."
  type        = string
}

variable "image_repository" {
  description = "Full container image repository path, e.g. myacr.azurecr.io/myapp."
  type        = string
}

variable "image_tag" {
  description = "Container image tag to deploy."
  type        = string
}

variable "replicas" {
  description = "Number of initial pod replicas. Overridden by HPA once it takes control."
  type        = number
  default     = 2
}

variable "cpu_request" {
  description = "CPU resource request for the application container, e.g. '100m'."
  type        = string
  default     = "100m"
}

variable "memory_request" {
  description = "Memory resource request for the application container, e.g. '128Mi'."
  type        = string
  default     = "128Mi"
}

variable "cpu_limit" {
  description = "CPU resource limit for the application container, e.g. '500m'."
  type        = string
  default     = "500m"
}

variable "memory_limit" {
  description = "Memory resource limit for the application container, e.g. '512Mi'."
  type        = string
  default     = "512Mi"
}

variable "hpa_min_replicas" {
  description = "Minimum replicas managed by HPA."
  type        = number
  default     = 2
}

variable "hpa_max_replicas" {
  description = "Maximum replicas managed by HPA."
  type        = number
  default     = 10
}

variable "hpa_cpu_target" {
  description = "Target average CPU utilization percentage for HPA scaling decisions."
  type        = number
  default     = 70
}

variable "ingress_enabled" {
  description = "When true, creates an Ingress resource for the application."
  type        = bool
  default     = true
}

variable "ingress_class" {
  description = "IngressClass to use for the Ingress resource."
  type        = string
  default     = "nginx"
}

variable "ingress_host" {
  description = "Hostname for the Ingress rule, e.g. myapp.example.com."
  type        = string
}

variable "ingress_tls_secret" {
  description = "Name of the TLS Secret for HTTPS termination. Leave null to disable TLS."
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables injected directly into the application container."
  type        = map(string)
  default     = {}
}

variable "config_data" {
  description = "Key-value pairs stored in a ConfigMap and exposed to the container via envFrom."
  type        = map(string)
  default     = {}
}

variable "service_type" {
  description = "Kubernetes Service type for the application."
  type        = string
  default     = "ClusterIP"
}

variable "service_port" {
  description = "Port exposed by the Service."
  type        = number
  default     = 80
}

variable "container_port" {
  description = "Port the application container listens on."
  type        = number
  default     = 8080
}

variable "enable_network_policy" {
  description = "When true, deploys a NetworkPolicy restricting ingress to the ingress-controller namespace."
  type        = bool
  default     = true
}

variable "extra_tags" {
  description = "Additional labels applied to all resources."
  type        = map(string)
  default     = {}
}
