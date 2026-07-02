#!/usr/bin/env bash
set -euo pipefail

ARGOCD_VERSION="${ARGOCD_VERSION:-v2.12.0}"
ARGOCD_NAMESPACE="${ARGOCD_NAMESPACE:-argocd}"

echo "==> Creating namespace ${ARGOCD_NAMESPACE}"
kubectl create namespace "${ARGOCD_NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

echo "==> Installing ArgoCD ${ARGOCD_VERSION}"
kubectl apply -n "${ARGOCD_NAMESPACE}" \
  -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

echo "==> Waiting for ArgoCD server to be ready"
kubectl rollout status deployment/argocd-server -n "${ARGOCD_NAMESPACE}" --timeout=300s

echo "==> Applying ArgoCD project"
kubectl apply -f "$(dirname "$0")/../argocd/projects/delivery.yaml"

echo "==> Applying root App of Apps"
kubectl apply -f "$(dirname "$0")/root-app.yaml"

echo ""
echo "ArgoCD installed and root app applied."
echo "Access the UI:"
echo "  kubectl port-forward svc/argocd-server -n ${ARGOCD_NAMESPACE} 8080:443"
echo ""
echo "Initial admin password:"
echo "  kubectl get secret argocd-initial-admin-secret -n ${ARGOCD_NAMESPACE} -o jsonpath='{.data.password}' | base64 -d"
