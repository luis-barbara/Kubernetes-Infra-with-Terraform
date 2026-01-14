#!/bin/bash
# Exibe status completo dos recursos

echo "======================================"
echo "   KUBERNETES CLUSTER STATUS"
echo "======================================"

echo ""
echo "📦 NAMESPACES"
echo "-----------------------------------"
kubectl get namespaces | grep -E "NAME|aigen|ingress-nginx"

echo ""
echo "🔧 PODS"
echo "-----------------------------------"
kubectl get pods -n aigen -o wide

echo ""
echo "🌐 SERVICES"
echo "-----------------------------------"
kubectl get svc -n aigen

echo ""
echo "🔗 INGRESS"
echo "-----------------------------------"
kubectl get ingress -n aigen

echo ""
echo "💾 PERSISTENT VOLUME CLAIMS"
echo "-----------------------------------"
kubectl get pvc -n aigen

echo ""
echo "🔐 SECRETS"
echo "-----------------------------------"
kubectl get secrets -n aigen

echo ""
echo "🎛️  INGRESS CONTROLLER"
echo "-----------------------------------"
kubectl get svc -n ingress-nginx ingress-nginx-controller

echo ""
echo "📊 DEPLOYMENTS"
echo "-----------------------------------"
kubectl get deployments -n aigen

echo ""
echo "🗄️  STATEFULSETS"
echo "-----------------------------------"
kubectl get statefulsets -n aigen

echo ""
echo "======================================"
echo "   MINIKUBE INFO"
echo "======================================"
minikube ip
echo "Minikube Status:"
minikube status

echo ""
