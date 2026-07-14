#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-kafka-learning}"

echo "Stopping local Kafka learning environment..."

kubectl delete namespace kafka argocd --ignore-not-found=true >/dev/null 2>&1 || true
helm uninstall argocd -n argocd --wait >/dev/null 2>&1 || true

if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
  echo "Deleting kind cluster '${CLUSTER_NAME}'..."
  kind delete cluster --name "$CLUSTER_NAME"
else
  echo "Cluster '${CLUSTER_NAME}' is not running."
fi

echo "Stopped."
