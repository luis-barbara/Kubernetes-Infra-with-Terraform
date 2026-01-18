#!/bin/bash
# Deploy complete infrastructure

set -e

echo "🏗️  Deploying Infrastructure..."
echo ""

cd "$(dirname "$0")/../terraform"

# Check if image exists
echo "📦 Checking Docker image..."
if ! docker images | grep -q "k8s.*latest"; then
    echo "⚠️  Image 'k8s:latest' not found!"
    echo "   Run: cd AI-IMAGE-GENERATOR && docker build -t k8s:latest ."
    exit 1
fi

# Create plan
echo ""
echo "📋 Creating execution plan..."
terraform plan -out=cluster.plan

echo ""
read -p "❓ Apply these changes? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Operation cancelled."
    exit 0
fi

# Apply
echo ""
echo "🚀 Applying infrastructure..."
terraform apply cluster.plan

# Get cluster name
CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null || echo "aigen-cluster")
NAMESPACE=$(terraform output -raw namespace 2>/dev/null || echo "aigen")

echo ""
echo "✅ Infrastructure created!"
echo ""

# Load image to cluster
echo "📦 Loading image to cluster..."
minikube -p "$CLUSTER_NAME" image load k8s:latest

# Import deployment if needed
echo ""
echo "🔄 Configuring deployment..."
if ! terraform state list | grep -q "kubernetes_deployment_v1.aigen_backend"; then
    terraform import kubernetes_deployment_v1.aigen_backend "$NAMESPACE/aigen" || true
fi

# Restart deployment
kubectl rollout restart deployment/aigen -n "$NAMESPACE"
kubectl rollout status deployment/aigen -n "$NAMESPACE" --timeout=300s

echo ""
echo "✅ Deployment ready!"
echo ""

# Show outputs
echo "📊 Infrastructure Info:"
terraform output

echo ""
echo "🌐 Access Application:"
echo ""
echo "Option 1 - Port Forward (Recommended for Windows/WSL):"
echo "  kubectl port-forward -n $NAMESPACE svc/aigen-service 8000:8000"
echo "  Open: http://localhost:8000"
echo ""
echo "Option 2 - HTTPS via Ingress:"
echo "  kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8443:443"
echo "  Open: https://localhost:8443"
echo ""
echo "Option 3 - Direct access (Linux/Mac):"
echo "  Add to /etc/hosts: \$(minikube -p $CLUSTER_NAME ip) aigen.local"
echo "  Open: https://aigen.local"
echo ""
