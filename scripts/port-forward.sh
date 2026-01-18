#!/usr/bin/env bash
set -euo pipefail

NAMESPACE_INGRESS="${NAMESPACE_INGRESS:-ingress-nginx}"
SVC="${SVC:-ingress-nginx-controller}"
LOCAL_PORT="${LOCAL_PORT:-8443}"
REMOTE_PORT="${REMOTE_PORT:-443}"

echo "🔒 HTTPS available at: https://localhost:${LOCAL_PORT}"
echo "Press CTRL+C to stop port-forward."
kubectl -n "${NAMESPACE_INGRESS}" port-forward "svc/${SVC}" "${LOCAL_PORT}:${REMOTE_PORT}"
