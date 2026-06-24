terraform {
  required_version = ">= 1.3.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20.0"
    }
  }
}

# Para conectar al AKS creado con el módulo aks:
# data "azurerm_kubernetes_cluster" "aks" {
#   name                = var.aks_name
#   resource_group_name = var.resource_group_name
# }
#
# provider "kubernetes" {
#   host = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# }
#
# Alternativa con kubeconfig local (desarrollo):
# provider "kubernetes" {
#   config_path    = var.kubeconfig_path
#   config_context = "minikube"
# }

provider "kubernetes" {
  config_path = var.kubeconfig_path
}
