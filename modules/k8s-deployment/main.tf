locals {
  pod_labels = merge(var.labels, { "app" = var.name })
}

resource "kubernetes_deployment_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  spec {
    replicas = var.hpa != null ? null : var.replicas

    selector {
      match_labels = local.pod_labels
    }

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = var.max_surge
        max_unavailable = var.max_unavailable
      }
    }

    template {
      metadata {
        labels      = local.pod_labels
        annotations = var.pod_annotations
      }

      spec {
        service_account_name = var.service_account_name != "" ? var.service_account_name : null
        node_selector        = length(var.node_selector) > 0 ? var.node_selector : null

        dynamic "toleration" {
          for_each = var.tolerations
          content {
            key      = toleration.value.key
            operator = toleration.value.operator
            value    = toleration.value.value
            effect   = toleration.value.effect
          }
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100
              pod_affinity_term {
                label_selector {
                  match_labels = local.pod_labels
                }
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        dynamic "init_container" {
          for_each = var.init_containers
          content {
            name              = init_container.value.name
            image             = init_container.value.image
            image_pull_policy = init_container.value.image_pull_policy

            dynamic "port" {
              for_each = init_container.value.ports
              content {
                name           = port.value.name
                container_port = port.value.container_port
                protocol       = port.value.protocol
              }
            }

            resources {
              requests = {
                for k, v in {
                  cpu    = try(init_container.value.resources.requests_cpu, null)
                  memory = try(init_container.value.resources.requests_memory, null)
                } : k => v if v != null
              }
              limits = {
                for k, v in {
                  cpu    = try(init_container.value.resources.limits_cpu, null)
                  memory = try(init_container.value.resources.limits_memory, null)
                } : k => v if v != null
              }
            }

            dynamic "env" {
              for_each = init_container.value.env
              content {
                name  = env.value.name
                value = env.value.value
              }
            }

            dynamic "env_from" {
              for_each = init_container.value.env_from_configmaps
              content {
                config_map_ref {
                  name = env_from.value
                }
              }
            }

            dynamic "env_from" {
              for_each = init_container.value.env_from_secrets
              content {
                secret_ref {
                  name = env_from.value
                }
              }
            }

            dynamic "volume_mount" {
              for_each = init_container.value.volume_mounts
              content {
                name       = volume_mount.value.name
                mount_path = volume_mount.value.mount_path
                read_only  = volume_mount.value.read_only
              }
            }
          }
        }

        dynamic "container" {
          for_each = var.containers
          content {
            name              = container.value.name
            image             = container.value.image
            image_pull_policy = container.value.image_pull_policy

            dynamic "port" {
              for_each = container.value.ports
              content {
                name           = port.value.name
                container_port = port.value.container_port
                protocol       = port.value.protocol
              }
            }

            resources {
              requests = {
                for k, v in {
                  cpu    = try(container.value.resources.requests_cpu, null)
                  memory = try(container.value.resources.requests_memory, null)
                } : k => v if v != null
              }
              limits = {
                for k, v in {
                  cpu    = try(container.value.resources.limits_cpu, null)
                  memory = try(container.value.resources.limits_memory, null)
                } : k => v if v != null
              }
            }

            dynamic "env" {
              for_each = container.value.env
              content {
                name  = env.value.name
                value = env.value.value
              }
            }

            dynamic "env_from" {
              for_each = container.value.env_from_configmaps
              content {
                config_map_ref {
                  name = env_from.value
                }
              }
            }

            dynamic "env_from" {
              for_each = container.value.env_from_secrets
              content {
                secret_ref {
                  name = env_from.value
                }
              }
            }

            dynamic "volume_mount" {
              for_each = container.value.volume_mounts
              content {
                name       = volume_mount.value.name
                mount_path = volume_mount.value.mount_path
                read_only  = volume_mount.value.read_only
              }
            }

            dynamic "liveness_probe" {
              for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []
              content {
                initial_delay_seconds = liveness_probe.value.initial_delay_seconds
                period_seconds        = liveness_probe.value.period_seconds
                failure_threshold     = liveness_probe.value.failure_threshold

                dynamic "http_get" {
                  for_each = liveness_probe.value.type == "http" ? [1] : []
                  content {
                    path = liveness_probe.value.path
                    port = liveness_probe.value.port
                  }
                }

                dynamic "exec" {
                  for_each = liveness_probe.value.type == "exec" ? [1] : []
                  content {
                    command = liveness_probe.value.command
                  }
                }

                dynamic "tcp_socket" {
                  for_each = liveness_probe.value.type == "tcp" ? [1] : []
                  content {
                    port = liveness_probe.value.port
                  }
                }
              }
            }

            dynamic "readiness_probe" {
              for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []
              content {
                initial_delay_seconds = readiness_probe.value.initial_delay_seconds
                period_seconds        = readiness_probe.value.period_seconds
                failure_threshold     = readiness_probe.value.failure_threshold

                dynamic "http_get" {
                  for_each = readiness_probe.value.type == "http" ? [1] : []
                  content {
                    path = readiness_probe.value.path
                    port = readiness_probe.value.port
                  }
                }

                dynamic "exec" {
                  for_each = readiness_probe.value.type == "exec" ? [1] : []
                  content {
                    command = readiness_probe.value.command
                  }
                }

                dynamic "tcp_socket" {
                  for_each = readiness_probe.value.type == "tcp" ? [1] : []
                  content {
                    port = readiness_probe.value.port
                  }
                }
              }
            }

            dynamic "startup_probe" {
              for_each = container.value.startup_probe != null ? [container.value.startup_probe] : []
              content {
                initial_delay_seconds = startup_probe.value.initial_delay_seconds
                period_seconds        = startup_probe.value.period_seconds
                failure_threshold     = startup_probe.value.failure_threshold

                dynamic "http_get" {
                  for_each = startup_probe.value.type == "http" ? [1] : []
                  content {
                    path = startup_probe.value.path
                    port = startup_probe.value.port
                  }
                }

                dynamic "exec" {
                  for_each = startup_probe.value.type == "exec" ? [1] : []
                  content {
                    command = startup_probe.value.command
                  }
                }

                dynamic "tcp_socket" {
                  for_each = startup_probe.value.type == "tcp" ? [1] : []
                  content {
                    port = startup_probe.value.port
                  }
                }
              }
            }
          }
        }

        dynamic "volume" {
          for_each = var.volumes
          content {
            name = volume.value.name

            dynamic "config_map" {
              for_each = volume.value.type == "configmap" ? [1] : []
              content {
                name = volume.value.source_name
              }
            }

            dynamic "secret" {
              for_each = volume.value.type == "secret" ? [1] : []
              content {
                secret_name = volume.value.source_name
              }
            }

            dynamic "empty_dir" {
              for_each = volume.value.type == "emptyDir" ? [1] : []
              content {}
            }

            dynamic "persistent_volume_claim" {
              for_each = volume.value.type == "pvc" ? [1] : []
              content {
                claim_name = volume.value.source_name
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "this" {
  count = var.hpa != null ? 1 : 0

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    min_replicas = var.hpa.min_replicas
    max_replicas = var.hpa.max_replicas

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.this.metadata[0].name
    }

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.hpa.cpu_average_utilization
        }
      }
    }
  }
}

resource "kubernetes_pod_disruption_budget_v1" "this" {
  count = var.pdb_min_available != null ? 1 : 0

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    min_available = var.pdb_min_available

    selector {
      match_labels = local.pod_labels
    }
  }
}
