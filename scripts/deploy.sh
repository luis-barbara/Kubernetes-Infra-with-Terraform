#!/bin/bash
# Deploy completo da aplicação

set -e

echo "🚀 Starting deployment..."

# Deploy database
echo "📊 Deploying database..."
kubectl apply -f k8s/database/

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n aigen --timeout=120s

# Deploy backend
echo "🐍 Deploying backend..."
kubectl apply -f k8s/backend-django-templates/

# Wait for backend to be ready
echo "⏳ Waiting for backend to be ready..."
kubectl wait --for=condition=ready pod -l app=aigen -n aigen --timeout=120s

# Deploy ingress
echo "🌐 Deploying ingress..."
kubectl apply -f k8s/ingress/

echo ""
echo "✅ Deployment complete!"
echo ""
kubectl get pods -n aigen
echo ""
echo "To access the application:"
echo "  1. Run: ./scripts/port-forward.sh"
echo "  2. Access: https://localhost:8443"
