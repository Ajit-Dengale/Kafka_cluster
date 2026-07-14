#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="argocd"

helm repo add argo https://argoproj.github.io/argo-helm >/dev/null 2>&1 || true
helm repo update

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install argocd argo/argo-cd \
  --namespace "$NAMESPACE" \
  --create-namespace \
  --values argocd/argocd-values.yaml \
  --wait --timeout 10m

kubectl -n "$NAMESPACE" rollout status deployment/argocd-server --timeout=10m

kubectl apply -f argocd/kafka-application.yaml

echo "Argo CD installed."
echo "Argo CD application created."
echo "To access the UI:"
echo "  kubectl -n argocd port-forward svc/argocd-server 8080:443"
echo "Initial admin password:"
kubectl -n "$NAMESPACE" get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
