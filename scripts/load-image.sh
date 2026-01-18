#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../terraform"

CLUSTER_NAME="$(terraform output -raw cluster_name 2>/dev/null || echo aigen-cluster)"
IMAGE="${IMAGE:-k8s:latest}"

echo "📦 Loading image into minikube profile: ${CLUSTER_NAME}"
minikube -p "${CLUSTER_NAME}" image load "${IMAGE}"

echo "✅ Image loaded"
