#!/bin/bash
# Build da imagem Docker no Minikube

set -e

echo "🔨 Building Docker image..."

# Configure to use Minikube's Docker daemon
eval $(minikube docker-env)

# Build the image
docker build -t k8s:latest ./AI-IMAGE-GENERATOR/

echo ""
echo "✅ Image 'k8s:latest' created successfully in Minikube!"
echo ""
echo "To verify: docker images | grep k8s"
