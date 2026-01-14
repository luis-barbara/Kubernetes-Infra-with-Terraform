.PHONY: help setup build deploy start stop status logs-backend logs-db restart migrate destroy clean all quickstart test

# Default target
help:
	@echo "=================================="
	@echo "  Kubernetes 3-Tier Web - Makefile"
	@echo "=================================="
	@echo ""
	@echo "Available commands:"
	@echo "  make setup         - Initial setup (namespace, secrets, ingress controller)"
	@echo "  make build         - Build Docker image in Minikube"
	@echo "  make deploy        - Deploy application (database, backend, ingress)"
	@echo "  make start         - Start port-forward to access application"
	@echo "  make stop          - Stop port-forward"
	@echo "  make status        - Show cluster status"
	@echo "  make logs-backend  - Show backend logs"
	@echo "  make logs-db       - Show database logs"
	@echo "  make restart       - Restart all pods"
	@echo "  make migrate       - Run Django migrations"
	@echo "  make test          - Run validation tests"
	@echo "  make destroy       - Remove all resources"
	@echo "  make clean         - Alias for destroy"
	@echo "  make all           - Run setup + build + deploy"
	@echo "  make quickstart    - Run setup + build + deploy + start"
	@echo ""
	@echo "Quick start:"
	@echo "  make quickstart"
	@echo ""

# Initial setup
setup:
	@./scripts/setup.sh

# Build Docker image
build:
	@./scripts/build.sh

# Deploy application
deploy:
	@./scripts/deploy.sh

# Start port-forward
start:
	@./scripts/port-forward.sh

# Stop port-forward
stop:
	@pkill -f "kubectl port-forward" 2>/dev/null || true
	@echo "✅ Port-forward stopped"

# Show status
status:
	@./scripts/status.sh

# Show backend logs
logs-backend:
	@./scripts/logs.sh backend

# Show database logs
logs-db:
	@./scripts/logs.sh db

# Restart pods
restart:
	@./scripts/restart.sh

# Run migrations
migrate:
	@./scripts/migrate.sh

# Run tests
test:
	@./scripts/test.sh

# Destroy all resources
destroy:
	@./scripts/destroy.sh

# Alias for destroy
clean: destroy

# Complete setup
all: setup build deploy
	@echo ""
	@echo "✅ Complete setup finished!"
	@echo "   Run 'make start' to access the application"

# Quick start - everything at once
quickstart: all
	@echo ""
	@echo "⏳ Waiting for all pods to be fully ready..."
	@kubectl wait --for=condition=ready pod -l app=postgres -n aigen --timeout=120s 2>/dev/null || true
	@kubectl wait --for=condition=ready pod -l app=aigen -n aigen --timeout=120s 2>/dev/null || true
	@sleep 10
	@echo ""
	@echo "🧪 Running validation tests..."
	@./scripts/test.sh
	@echo ""
	@echo "🚀 Starting port-forward..."
	@./scripts/port-forward.sh
