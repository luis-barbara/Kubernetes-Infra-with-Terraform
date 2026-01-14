#!/bin/bash
# Cleanup completo de todos os recursos

set -e

echo "🗑️  Removing resources..."

# Stop port-forward if running
echo "🛑 Stopping port-forwards..."
pkill -f "kubectl port-forward" 2>/dev/null || true

# Delete resources
echo "📦 Deleting ingress..."
kubectl delete -f k8s/ingress/ --ignore-not-found=true

echo "🐍 Deleting backend..."
kubectl delete -f k8s/backend-django-templates/ --ignore-not-found=true

echo "📊 Deleting database..."
kubectl delete -f k8s/database/ --ignore-not-found=true

echo "🗂️  Deleting namespace..."
kubectl delete namespace aigen --ignore-not-found=true

# Stop minikube tunnel
echo "🌐 Stopping minikube tunnel..."
pkill -f "minikube tunnel" 2>/dev/null || true

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "To recreate everything:"
echo "  1. ./scripts/setup.sh"
echo "  2. ./scripts/build.sh"
echo "  3. ./scripts/deploy.sh"
