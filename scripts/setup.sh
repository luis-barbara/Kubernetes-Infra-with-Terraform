#!/bin/bash
# Setup inicial do ambiente Kubernetes

set -e

echo "🚀 Starting setup..."

# Create namespace
echo "📦 Creating namespace..."
kubectl apply -f k8s/namespaces/namespaces.yaml

# Create certificates directory if it doesn't exist
mkdir -p k8s/ingress/certs

# Create self-signed TLS certificates
echo "🔒 Creating TLS certificates..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout k8s/ingress/certs/tls.key \
  -out k8s/ingress/certs/tls.crt \
  -subj "/CN=aigen.local/O=aigen" 2>/dev/null

# Create TLS secret
echo "🔐 Creating TLS secret..."
kubectl create secret tls aigen-tls-secret \
  --cert=k8s/ingress/certs/tls.crt \
  --key=k8s/ingress/certs/tls.key \
  -n aigen --dry-run=client -o yaml | kubectl apply -f -

# Create application secrets
echo "🔑 Creating application secrets..."
kubectl apply -f k8s/database/secret.yaml
kubectl apply -f k8s/backend-django-templates/secret.yaml

# Install NGINX Ingress Controller if it doesn't exist
if ! kubectl get namespace ingress-nginx &> /dev/null; then
    echo "📥 Installing NGINX Ingress Controller..."
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
    echo "⏳ Waiting for Ingress Controller to be ready..."
    kubectl wait --namespace ingress-nginx \
      --for=condition=ready pod \
      --selector=app.kubernetes.io/component=controller \
      --timeout=120s
else
    echo "✅ NGINX Ingress Controller already installed"
fi

# Start minikube tunnel in background
echo "🌐 Starting minikube tunnel..."
pkill -f "minikube tunnel" 2>/dev/null || true
nohup minikube tunnel > /tmp/minikube-tunnel.log 2>&1 &
echo "   Tunnel PID: $!"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Run: ./scripts/build.sh"
echo "  2. Run: ./scripts/deploy.sh"
echo "  3. Run: ./scripts/port-forward.sh"
