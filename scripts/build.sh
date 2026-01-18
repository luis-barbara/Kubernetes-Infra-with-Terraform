#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-k8s:latest}"
APP_DIR="${APP_DIR:-AI-IMAGE-GENERATOR}"

echo "🐳 Building image: ${IMAGE}"
docker build -t "${IMAGE}" "./${APP_DIR}"
echo "✅ Build done"
