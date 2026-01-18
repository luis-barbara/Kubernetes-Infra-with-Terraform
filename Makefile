.PHONY: help init build load apply deploy test destroy clean status outputs http https quickstart

help:
@echo "========================================"
@echo "  Kubernetes (Terraform) - Makefile"
@echo "========================================"
@echo ""
@echo "Main:"
@echo "  make quickstart   - init + build + apply + test + https"
@echo "  make deploy       - build + apply"
@echo "  make destroy      - teardown"
@echo ""
@echo "Terraform:"
@echo "  make init         - terraform init + validate"
@echo "  make apply        - terraform plan + apply"
@echo "  make outputs      - terraform output"
@echo ""
@echo "Image (Minikube):"
@echo "  make build        - docker build (k8s:latest)"
@echo "  make load         - minikube image load (k8s:latest)"
@echo ""
@echo "Access:"
@echo "  make https        - port-forward ingress to [https://localhost:8443](https://localhost:8443)"
@echo "  make http         - port-forward app svc to [http://localhost:8000](http://localhost:8000)"
@echo ""

init:
@./scripts/init.sh

build:
@./scripts/build.sh

load:
@./scripts/load-image.sh

apply:
@./scripts/apply.sh

deploy: build apply

test:
@./scripts/test.sh

outputs:
@cd terraform && terraform output

status:
@cd terraform && 
NAMESPACE=$$(terraform output -raw namespace 2>/dev/null || echo aigen) && 
kubectl get all,ingress,pvc,secrets,cm -n $$NAMESPACE

http:
@cd terraform && 
NAMESPACE=$$(terraform output -raw namespace 2>/dev/null || echo aigen) && 
echo "HTTP: [http://localhost:8000](http://localhost:8000)" && 
kubectl -n $$NAMESPACE port-forward svc/aigen-service 8000:8000

https:
@./scripts/port-forward-https.sh

destroy:
@./scripts/destroy.sh

clean: destroy

quickstart: init build apply test https

