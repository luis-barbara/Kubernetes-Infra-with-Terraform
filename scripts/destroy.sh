#!/bin/bash
# Destroy all infrastructure

set -e

echo "⚠️  WARNING: This will DESTROY all infrastructure!"
echo ""

read -p "❓ Are you sure? Type 'destroy' to confirm: " confirm

if [ "$confirm" != "destroy" ]; then
    echo "❌ Operation cancelled."
    exit 0
fi

cd "$(dirname "$0")/../terraform"

echo ""
echo "🗑️  Destroying infrastructure..."

# Destroy with auto-approve
terraform destroy -auto-approve

echo ""
echo "✅ Infrastructure destroyed!"
echo ""
echo "🧹 Optional cleanup:"
echo "   minikube delete --all"
echo "   docker system prune -a"
echo ""