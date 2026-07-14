#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="kafka"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f kafka/kafka-kraft-manifest.yaml

for attempt in $(seq 1 60); do
  if kubectl -n "$NAMESPACE" get pod/kafka-0 >/dev/null 2>&1; then
    break
  fi
  sleep 5
done

kubectl -n "$NAMESPACE" wait --for=condition=Ready pod/kafka-0 --timeout=10m

echo "Kafka deployment installed."
echo "Inspect pods with:"
echo "  kubectl -n kafka get pods"
