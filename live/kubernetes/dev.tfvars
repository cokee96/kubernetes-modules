namespace        = "myapp-dev"
app_name         = "myapp"
image_repository = "myacr.azurecr.io/myapp"
image_tag        = "latest"

# Replicas — dev runs lean
replicas         = 1
hpa_min_replicas = 1
hpa_max_replicas = 3
hpa_cpu_target   = 70

# Resources — small for dev
cpu_request    = "100m"
memory_request = "128Mi"
cpu_limit      = "250m"
memory_limit   = "256Mi"

# Service
service_type   = "ClusterIP"
service_port   = 80
container_port = 8080

# Ingress — no TLS in dev
ingress_enabled    = true
ingress_class      = "nginx"
ingress_host       = "myapp.dev.example.com"
ingress_tls_secret = null

# Network policy
enable_network_policy = true

# App config
config_data = {
  LOG_LEVEL    = "debug"
  ENVIRONMENT  = "dev"
  FEATURE_FLAG = "true"
}

environment_variables = {
  APP_ENV = "development"
}

extra_tags = {
  environment = "dev"
  team        = "platform"
}
