# Lightweight Kafka learning cluster on kind

This workspace contains a small, low-memory setup for learning Kafka on Kubernetes with:

- kind for a local Kubernetes cluster
- Helm for package management
- Argo CD for GitOps-style deployment automation

It is tuned for a machine with about 8 GiB RAM and limited CPU.

The Kafka part uses Strimzi with a KRaft-based configuration so you avoid the extra ZooKeeper overhead while keeping the setup simple.

## Step 1: verify prerequisites

Make sure these tools are installed:

- docker
- kind
- kubectl
- helm

You can verify them with:

```bash
command -v docker kind kubectl helm
```

## Step 2: create the lightweight kind cluster

```bash
./scripts/create-kind-cluster.sh
```

This creates a single-node cluster that is suitable for learning and light testing.

## Step 3: install Argo CD with Helm

```bash
./scripts/install-argocd.sh
```

## Step 4: install a tiny Kafka environment with Strimzi

```bash
./scripts/install-kafka.sh
```

This deploys a single-broker Kafka cluster from the YAML manifest in [kafka/kafka-kraft.yaml](kafka/kafka-kraft.yaml). The Helm values are in [kafka/strimzi-values.yaml](kafka/strimzi-values.yaml), so you can inspect and update them later.

## Step 5: stop or start everything later

If you want a simple way to pause or restart the whole local environment, use:

```bash
./scripts/stop-everything.sh
./scripts/start-everything.sh
```

The stop script removes the Kafka and Argo CD namespaces and deletes the kind cluster. The start script recreates the cluster and re-runs the Argo CD and Kafka setup.

## Step 6: access the tools

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
- If you want, the next step can be adding a simple producer/consumer test, topic creation, or a sample Argo CD app that deploys Kafka-related resources.
