resource "kubernetes_cron_job_v1" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }

  spec {
    schedule                      = var.schedule
    concurrency_policy            = var.concurrency_policy
    successful_jobs_history_limit = var.successful_jobs_history_limit
    failed_jobs_history_limit     = var.failed_jobs_history_limit

    job_template {
      metadata {
        labels = var.labels
      }

      spec {
        template {
          metadata {
            labels = var.labels
          }

          spec {
            restart_policy = var.restart_policy

            dynamic "container" {
              for_each = var.containers
              content {
                name              = container.value.name
                image             = container.value.image
                image_pull_policy = container.value.image_pull_policy

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
              }
            }
          }
        }
      }
    }
  }
}
