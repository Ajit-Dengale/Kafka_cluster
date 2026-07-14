# Lightweight Kafka learning cluster on kind

This workspace contains a small, low-memory setup for learning Kafka on Kubernetes with:

- kind for a local Kubernetes cluster
- Argo CD for GitOps-style deployment automation
- a single-broker Kafka deployment using KRaft, with no ZooKeeper

It is tuned for a machine with about 8 GiB RAM and limited CPU.

## Prerequisites

Make sure these tools are installed:

- docker
- kind
- kubectl
- helm

You can verify them with:

```bash
command -v docker kind kubectl helm
```

## Start everything

Use the convenience script to recreate the cluster and install both Argo CD and Kafka:

```bash
./scripts/start-everything.sh
```

## Stop everything

To stop and remove the entire local environment:

```bash
./scripts/stop-everything.sh
```

## Manual steps

If you want to run the pieces separately:

```bash
./scripts/create-kind-cluster.sh
./scripts/install-argocd.sh
./scripts/install-kafka.sh
```

## Access the tools

### Argo CD UI

```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

Open http://localhost:8080 and sign in with:

- username: admin
- password: the value from

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Kafka pods

```bash
kubectl -n kafka get pods
```

## Notes

- This setup is intentionally minimal to stay within a low-RAM machine.
- The Kafka deployment is driven by the manifest in [kafka/kafka-kraft-manifest.yaml](kafka/kafka-kraft-manifest.yaml).

