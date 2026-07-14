#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-kafka-learning}"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Cluster '${CLUSTER_NAME}' already exists."
  exit 0
fi

echo "Creating kind cluster '${CLUSTER_NAME}'..."
if command -v docker >/dev/null 2>&1; then
  docker ps -a --filter "name=${CLUSTER_NAME}-" --format '{{.Names}}' | while read -r container; do
    docker rm -f "$container" >/dev/null 2>&1 || true
  done
fi
kind create cluster --name "$CLUSTER_NAME" --config kind/cluster-config.yaml
kind export kubeconfig --name "$CLUSTER_NAME"

echo "Waiting for nodes to become ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=5m

echo "Cluster is ready."
kubectl get nodes
