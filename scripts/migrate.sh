#!/bin/bash
# Executa migrations do Django

set -e

echo "🔄 Running Django migrations..."

# Get backend pod name
POD=$(kubectl get pod -n aigen -l app=aigen -o jsonpath="{.items[0].metadata.name}")

if [ -z "$POD" ]; then
    echo "❌ No backend pod found!"
    exit 1
fi

echo "📦 Pod: $POD"
echo ""

# Run migrations
kubectl exec -it $POD -n aigen -- python manage.py migrate

echo ""
echo "✅ Migrations executed successfully!"
