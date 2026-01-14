#!/bin/bash
# Reinicia os pods

set -e

echo "🔄 Restarting pods..."

# Restart backend deployment
echo "🐍 Restarting backend..."
kubectl rollout restart deployment/aigen -n aigen

# Restart database statefulset
echo "📊 Restarting database..."
kubectl rollout restart statefulset/postgres -n aigen

echo ""
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n aigen --timeout=120s
kubectl wait --for=condition=ready pod -l app=aigen -n aigen --timeout=120s

echo ""
echo "✅ Pods restarted successfully!"
echo ""
kubectl get pods -n aigen
