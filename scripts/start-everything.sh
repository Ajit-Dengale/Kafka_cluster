#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTER_NAME="${CLUSTER_NAME:-kafka-learning}"

cd "$ROOT_DIR"

echo "Starting local Kafka learning environment..."

if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
  echo "Removing existing kind cluster '${CLUSTER_NAME}'..."
  kind delete cluster --name "$CLUSTER_NAME"
fi

./scripts/create-kind-cluster.sh
./scripts/install-argocd.sh
./scripts/install-kafka.sh

echo "Everything is started."
echo "Useful commands:"
echo "  kubectl -n kafka get pods"
echo "  kubectl -n argocd get pods"
