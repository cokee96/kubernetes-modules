resource "kubernetes_service_v1" "this" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.annotations
  }

  spec {
    type             = var.type
    selector         = var.selector
    cluster_ip       = var.headless ? "None" : null
    load_balancer_ip = var.type == "LoadBalancer" && var.load_balancer_ip != null ? var.load_balancer_ip : null

    dynamic "port" {
      for_each = var.ports
      content {
        name        = port.value.name
        port        = port.value.port
        target_port = port.value.target_port
        protocol    = port.value.protocol
        node_port   = port.value.node_port
      }
    }
  }
}
