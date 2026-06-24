module "namespace" {
  source = "../../modules/k8s-namespace"

  name   = var.namespace
  labels = local.common_labels
}

module "serviceaccount" {
  source = "../../modules/k8s-serviceaccount"

  name      = var.app_name
  namespace = module.namespace.name
  labels    = local.common_labels

  automount_token = false

  depends_on = [module.namespace]
}

module "configmap" {
  count  = length(var.config_data) > 0 ? 1 : 0
  source = "../../modules/k8s-configmap"

  name      = "${var.app_name}-config"
  namespace = module.namespace.name
  labels    = local.common_labels
  data      = var.config_data

  depends_on = [module.namespace]
}

module "deployment" {
  source = "../../modules/k8s-deployment"

  name      = var.app_name
  namespace = module.namespace.name
  labels    = local.common_labels

  pod_annotations = {
    "prometheus.io/scrape" = "true"
    "prometheus.io/port"   = tostring(var.container_port)
    "prometheus.io/path"   = "/metrics"
  }

  replicas             = var.replicas
  service_account_name = module.serviceaccount.name

  containers = [
    {
      name              = var.app_name
      image             = "${var.image_repository}:${var.image_tag}"
      image_pull_policy = "Always"

      ports = [
        {
          name           = "http"
          container_port = var.container_port
          protocol       = "TCP"
        }
      ]

      resources = {
        requests_cpu    = var.cpu_request
        requests_memory = var.memory_request
        limits_cpu      = var.cpu_limit
        limits_memory   = var.memory_limit
      }

      env = [
        for k, v in var.environment_variables : {
          name  = k
          value = v
        }
      ]

      env_from_configmaps = length(var.config_data) > 0 ? ["${var.app_name}-config"] : []
      env_from_secrets    = []
      volume_mounts       = []

      liveness_probe = {
        type                  = "http"
        path                  = "/healthz"
        port                  = var.container_port
        initial_delay_seconds = 30
        period_seconds        = 10
        failure_threshold     = 3
      }

      readiness_probe = {
        type                  = "http"
        path                  = "/ready"
        port                  = var.container_port
        initial_delay_seconds = 10
        period_seconds        = 5
        failure_threshold     = 3
      }

      startup_probe = null
    }
  ]

  hpa = {
    min_replicas            = var.hpa_min_replicas
    max_replicas            = var.hpa_max_replicas
    cpu_average_utilization = var.hpa_cpu_target
  }

  pdb_min_available = var.replicas > 1 ? "1" : null

  depends_on = [module.namespace, module.serviceaccount, module.configmap]
}

module "service" {
  source = "../../modules/k8s-service"

  name      = var.app_name
  namespace = module.namespace.name
  labels    = local.common_labels

  type     = var.service_type
  selector = { "app" = var.app_name }

  ports = [
    {
      name        = "http"
      port        = var.service_port
      target_port = var.container_port
      protocol    = "TCP"
    }
  ]

  depends_on = [module.namespace]
}

module "ingress" {
  count  = var.ingress_enabled ? 1 : 0
  source = "../../modules/k8s-ingress"

  name      = var.app_name
  namespace = module.namespace.name
  labels    = local.common_labels

  annotations = {
    "nginx.ingress.kubernetes.io/ssl-redirect"       = var.ingress_tls_secret != null ? "true" : "false"
    "nginx.ingress.kubernetes.io/proxy-body-size"    = "10m"
    "nginx.ingress.kubernetes.io/proxy-read-timeout" = "60"
  }

  ingress_class = var.ingress_class

  tls = var.ingress_tls_secret != null ? [
    {
      hosts       = [var.ingress_host]
      secret_name = var.ingress_tls_secret
    }
  ] : []

  rules = [
    {
      host = var.ingress_host
      paths = [
        {
          path         = "/"
          path_type    = "Prefix"
          service_name = var.app_name
          service_port = var.service_port
        }
      ]
    }
  ]

  depends_on = [module.service]
}

module "hpa" {
  source = "../../modules/k8s-hpa"

  name      = var.app_name
  namespace = module.namespace.name

  target_name                = module.deployment.name
  target_kind                = "Deployment"
  min_replicas               = var.hpa_min_replicas
  max_replicas               = var.hpa_max_replicas
  cpu_average_utilization    = var.hpa_cpu_target
  memory_average_utilization = null

  scale_down_stabilization_seconds = 300

  depends_on = [module.deployment]
}

module "networkpolicy" {
  count  = var.enable_network_policy ? 1 : 0
  source = "../../modules/k8s-networkpolicy"

  name      = "${var.app_name}-netpol"
  namespace = module.namespace.name
  labels    = local.common_labels

  pod_selector = { "app" = var.app_name }
  policy_types = ["Ingress", "Egress"]

  ingress_rules = [
    {
      from_namespace_selector = { "kubernetes.io/metadata.name" = "ingress-nginx" }
      from_pod_selector       = null
      ports = [
        {
          port     = var.container_port
          protocol = "TCP"
        }
      ]
    }
  ]

  egress_rules = [
    {
      from_pod_selector       = null
      from_namespace_selector = null
      ports = [
        {
          port     = 53
          protocol = "UDP"
        },
        {
          port     = 53
          protocol = "TCP"
        }
      ]
    },
    {
      from_pod_selector       = null
      from_namespace_selector = null
      ports = [
        {
          port     = 443
          protocol = "TCP"
        },
        {
          port     = 80
          protocol = "TCP"
        }
      ]
    }
  ]

  depends_on = [module.namespace]
}
