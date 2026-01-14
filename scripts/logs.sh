#!/bin/bash
# Exibe logs dos pods

POD_TYPE=${1:-backend}

if [ "$POD_TYPE" = "backend" ]; then
    echo "📋 Django Backend Logs:"
    echo "-----------------------------------"
    kubectl logs -f -n aigen -l app=aigen --tail=100
elif [ "$POD_TYPE" = "db" ]; then
    echo "📋 PostgreSQL Logs:"
    echo "-----------------------------------"
    kubectl logs -f -n aigen -l app=postgres --tail=100
else
    echo "❌ Usage: ./logs.sh [backend|db]"
    echo ""
    echo "Examples:"
    echo "  ./logs.sh backend  # View Django logs"
    echo "  ./logs.sh db       # View PostgreSQL logs"
    exit 1
fi
