#!/bin/bash
# Inicia port-forward para acessar a aplicação via HTTPS

set -e

echo "🌐 Starting HTTPS port-forward..."

# Stop previous port-forwards
pkill -f "kubectl port-forward" 2>/dev/null || true
sleep 2

# Start port-forward
echo "🔗 Port-forward: localhost:8443 -> ingress-nginx:443"
kubectl port-forward -n ingress-nginx service/ingress-nginx-controller 8443:443 --address=0.0.0.0 &
PF_PID=$!

echo ""
echo "✅ Port-forward active (PID: $PF_PID)"
echo ""
echo "🌍 Access the application at: https://localhost:8443"
echo ""
echo "⚠️  Accept the self-signed certificate in your browser"
echo ""
echo "To stop: pkill -f 'kubectl port-forward'"
echo ""
echo "Port-forward logs:"
echo "-------------------"
wait $PF_PID
