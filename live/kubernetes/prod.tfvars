namespace        = "myapp-prod"
app_name         = "myapp"
image_repository = "myacr.azurecr.io/myapp"
image_tag        = "stable"

# Replicas — production HA minimum 3
replicas         = 3
hpa_min_replicas = 3
hpa_max_replicas = 20
hpa_cpu_target   = 60

# Resources — large for production
cpu_request    = "500m"
memory_request = "512Mi"
cpu_limit      = "1000m"
memory_limit   = "1Gi"

# Service
service_type   = "ClusterIP"
service_port   = 80
container_port = 8080

# Ingress — TLS enabled in prod
ingress_enabled    = true
ingress_class      = "nginx"
ingress_host       = "myapp.example.com"
ingress_tls_secret = "myapp-tls"

# Network policy — enforce strict ingress in prod
enable_network_policy = true

# App config
config_data = {
  LOG_LEVEL   = "warn"
  ENVIRONMENT = "prod"
}

environment_variables = {
  APP_ENV = "production"
}

extra_tags = {
  environment = "prod"
  team        = "platform"
  criticality = "high"
}
