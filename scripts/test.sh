#!/bin/bash
# Test the deployed application

set -e

echo "🧪 Testing Infrastructure..."
echo ""

cd "$(dirname "$0")/../terraform"

# Get values
NAMESPACE=$(terraform output -raw namespace 2>/dev/null || echo "aigen")
CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null || echo "aigen-cluster")

# 1. Check cluster
echo "1️⃣  Checking cluster..."
minikube status -p "$CLUSTER_NAME"

# 2. Check namespace
echo ""
echo "2️⃣  Checking namespace..."
kubectl get namespace "$NAMESPACE"

# 3. Check pods
echo ""
echo "3️⃣  Checking pods..."
kubectl get pods -n "$NAMESPACE"

# 4. Check services
echo ""
echo "4️⃣  Checking services..."
kubectl get svc -n "$NAMESPACE"

# 5. Check ingress
echo ""
echo "5️⃣  Checking ingress..."
kubectl get ingress -n "$NAMESPACE"

# 6. Check PVC
echo ""
echo "6️⃣  Checking PVC..."
kubectl get pvc -n "$NAMESPACE"

# 7. Wait for pods
echo ""
echo "7️⃣  Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n "$NAMESPACE" --timeout=60s
kubectl wait --for=condition=ready pod -l app=aigen -n "$NAMESPACE" --timeout=60s

# 8. Test PostgreSQL
echo ""
echo "8️⃣  Testing PostgreSQL connection..."
POSTGRES_POD=$(kubectl get pod -n "$NAMESPACE" -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n "$NAMESPACE" "$POSTGRES_POD" -- psql -U postgres -c '\l' || echo "⚠️  PostgreSQL not ready yet"

# 9. Test backend logs
echo ""
echo "9️⃣  Checking backend logs..."
BACKEND_POD=$(kubectl get pod -n "$NAMESPACE" -l app=aigen -o jsonpath='{.items[0].metadata.name}')
kubectl logs -n "$NAMESPACE" "$BACKEND_POD" --tail=20 || echo "⚠️  Backend has no logs yet"

# 10. Port-forward test
echo ""
echo "🔟 Testing HTTP access..."
kubectl port-forward -n "$NAMESPACE" svc/aigen-service 8000:8000 &
PF_PID=$!
sleep 3
curl -s -o /dev/null -w "Status: %{http_code}\n" http://localhost:8000 || echo "⚠️  Service not accessible yet"
kill $PF_PID 2>/dev/null || true

echo ""
echo "✅ All tests completed!"
echo ""
echo "📌 Access application:"
echo "   kubectl port-forward -n $NAMESPACE svc/aigen-service 8000:8000"
echo "   Open: http://localhost:8000"
echo ""
echo "📌 View logs:"
echo "   kubectl logs -f -n $NAMESPACE -l app=aigen"
echo ""
echo "📌 Access PostgreSQL:"
echo "   kubectl exec -it -n $NAMESPACE $POSTGRES_POD -- psql -U postgres -d dali_db"
echo ""
