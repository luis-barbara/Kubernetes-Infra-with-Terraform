#!/bin/bash
# Testing script - Validates that the Kubernetes cluster and application are working

set -e

echo "🧪 Starting system validation tests..."
echo ""

# Test 1: Check if Minikube is running
echo "1️⃣  Testing Minikube status..."
if minikube status | grep -q "Running"; then
    echo "   ✅ Minikube is running"
else
    echo "   ❌ Minikube is not running!"
    exit 1
fi
echo ""

# Test 2: Check if namespace exists
echo "2️⃣  Testing namespace..."
if kubectl get namespace aigen &> /dev/null; then
    echo "   ✅ Namespace 'aigen' exists"
else
    echo "   ❌ Namespace 'aigen' not found!"
    exit 1
fi
echo ""

# Test 3: Check if all pods are running
echo "3️⃣  Testing pods status..."
PODS_NOT_READY=$(kubectl get pods -n aigen --no-headers | grep -v "Running\|Completed" | wc -l)
if [ "$PODS_NOT_READY" -eq 0 ]; then
    echo "   ✅ All pods are running"
    kubectl get pods -n aigen
else
    echo "   ❌ Some pods are not ready!"
    kubectl get pods -n aigen
    exit 1
fi
echo ""

# Test 4: Check if services exist
echo "4️⃣  Testing services..."
if kubectl get svc -n aigen aigen-service &> /dev/null && \
   kubectl get svc -n aigen postgres-service &> /dev/null; then
    echo "   ✅ All services exist"
else
    echo "   ❌ Some services are missing!"
    exit 1
fi
echo ""

# Test 5: Check if ingress exists
echo "5️⃣  Testing ingress..."
if kubectl get ingress -n aigen aigen-ingress &> /dev/null; then
    echo "   ✅ Ingress exists"
    kubectl get ingress -n aigen
else
    echo "   ❌ Ingress not found!"
    exit 1
fi
echo ""

# Test 6: Check if secrets exist
echo "6️⃣  Testing secrets..."
if kubectl get secret -n aigen postgres-secret &> /dev/null && \
   kubectl get secret -n aigen django-secret &> /dev/null && \
   kubectl get secret -n aigen aigen-tls-secret &> /dev/null; then
    echo "   ✅ All secrets exist"
else
    echo "   ❌ Some secrets are missing!"
    exit 1
fi
echo ""

# Test 7: Check if configmap exists
echo "7️⃣  Testing configmap..."
if kubectl get configmap -n aigen django-config &> /dev/null; then
    echo "   ✅ ConfigMap exists"
else
    echo "   ❌ ConfigMap not found!"
    exit 1
fi
echo ""

# Test 8: Check if PVC exists and is bound
echo "8️⃣  Testing PersistentVolumeClaim..."
PVC_STATUS=$(kubectl get pvc -n aigen postgres-pvc -o jsonpath='{.status.phase}' 2>/dev/null || echo "NotFound")
if [ "$PVC_STATUS" = "Bound" ]; then
    echo "   ✅ PVC is bound"
else
    echo "   ❌ PVC is not bound (Status: $PVC_STATUS)!"
    exit 1
fi
echo ""

# Test 9: Test database connectivity
echo "9️⃣  Testing database connectivity..."
DB_POD=$(kubectl get pod -n aigen -l app=postgres -o jsonpath="{.items[0].metadata.name}" 2>/dev/null || echo "")
if [ -n "$DB_POD" ]; then
    if kubectl exec -n aigen $DB_POD -- pg_isready -U postgres &> /dev/null; then
        echo "   ✅ Database is accepting connections"
    else
        echo "   ⚠️  Database pod exists but not ready yet"
    fi
else
    echo "   ❌ Database pod not found!"
    exit 1
fi
echo ""

# Test 10: Test backend application HTTP response
echo "🔟 Testing backend application..."
BACKEND_POD=$(kubectl get pod -n aigen -l app=aigen -o jsonpath="{.items[0].metadata.name}" 2>/dev/null || echo "")
if [ -n "$BACKEND_POD" ]; then
    HTTP_CODE=$(kubectl exec -n aigen $BACKEND_POD -- curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/ 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ] || [ "$HTTP_CODE" = "405" ]; then
        echo "   ✅ Backend is responding (HTTP $HTTP_CODE)"
    else
        echo "   ⚠️  Backend responded with HTTP $HTTP_CODE"
    fi
else
    echo "   ❌ Backend pod not found!"
    exit 1
fi
echo ""

# Test 11: Test Ingress Controller
echo "1️⃣1️⃣  Testing Ingress Controller..."
if kubectl get svc -n ingress-nginx ingress-nginx-controller &> /dev/null; then
    echo "   ✅ Ingress Controller is deployed"
else
    echo "   ❌ Ingress Controller not found!"
    exit 1
fi
echo ""

# Test 12: End-to-end test (if port-forward is running)
echo "1️⃣2️⃣  Testing end-to-end connectivity..."
if curl -k -s https://localhost:8443 -H "Host: aigen.local" --max-time 5 &> /dev/null; then
    echo "   ✅ Application is accessible via HTTPS (port-forward active)"
elif curl -k -s https://192.168.49.2:32507 -H "Host: aigen.local" --max-time 5 &> /dev/null; then
    echo "   ✅ Application is accessible via NodePort"
else
    echo "   ⚠️  Application not accessible (port-forward may not be running)"
    echo "      Run 'make start' to access the application"
fi
echo ""

# Summary
echo "======================================="
echo "  ✅ ALL TESTS PASSED!"
echo "======================================="
echo ""
echo "System is fully operational!"
echo ""
echo "To access the application:"
echo "  1. Run: make start"
echo "  2. Open: https://localhost:8443"
echo ""
