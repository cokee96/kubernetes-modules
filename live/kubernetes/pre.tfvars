namespace        = "myapp-pre"
app_name         = "myapp"
image_repository = "myacr.azurecr.io/myapp"
image_tag        = "latest"

# Replicas — pre matches prod topology
replicas         = 2
hpa_min_replicas = 2
hpa_max_replicas = 6
hpa_cpu_target   = 70

# Resources — medium for pre-production
cpu_request    = "200m"
memory_request = "256Mi"
cpu_limit      = "500m"
memory_limit   = "512Mi"

# Service
service_type   = "ClusterIP"
service_port   = 80
container_port = 8080

# Ingress — no TLS in pre (can be enabled for testing)
ingress_enabled    = true
ingress_class      = "nginx"
ingress_host       = "myapp.pre.example.com"
ingress_tls_secret = null

# Network policy
enable_network_policy = true

# App config
config_data = {
  LOG_LEVEL   = "info"
  ENVIRONMENT = "pre"
}

environment_variables = {
  APP_ENV = "staging"
}

extra_tags = {
  environment = "pre"
  team        = "platform"
}
