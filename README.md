# Kubernetes 3-Tier Infrastructure with Terraform

AI Image Generator (Django + PostgreSQL) deployed on Kubernetes (Minikube) using Terraform Infrastructure as Code.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Relationship to Previous Exercise](#-relationship-to-previous-exercise)
- [Architecture](#️-architecture)
- [Prerequisites](#️-prerequisites)
- [Quick Start](#-quick-start-recommended)
- [Useful Commands](#-useful-commands)
- [Project Structure](#-project-structure)
- [Configuration](#-configuration)
- [Testing](#-testing)
- [Destroy Environment](#️-destroy-environment)
- [Known Limitations](#️-known-limitations)
- [Troubleshooting](#-troubleshooting)
- [References](#-references)
- [Important Notes](#-important-notes)
- [Author](#-author)
- [License](#-license)

---

## 🎯 Overview

This project deploys a 3-tier application:

- **Application Layer**: Django (AI Image Generator)
- **Database Layer**: PostgreSQL 17 (StatefulSet + PVC)
- **Networking Layer**: Kubernetes Service + NGINX Ingress + TLS

All Kubernetes resources are created using **Terraform Kubernetes Provider** (**no `kubectl apply -f`**).

---

## 🔄 Relationship to Previous Exercise

### What was REUSED
- Same Django application (AI Image Generator)
- Same PostgreSQL database
- Same architecture (App + DB + Ingress)
- Same environment variables (ConfigMaps + Secrets)
- Same persistence (PVC)

### What changed (YAML → Terraform)
- Kubernetes resources are now created using **Terraform**
- Infrastructure is modularized into multiple `.tf` files
- Variables and outputs are used for configuration
- Automation scripts + Makefile added (`init`, `apply`, `test`, `destroy`)
- Secrets are configured via `terraform.tfvars` (not hardcoded)

### Terraform Advantages over YAML
- **State management**: Terraform tracks what exists
- **Plan before apply**: Preview changes before execution
- **Modular code**: Easier to maintain and reuse
- **Easy destroy**: Remove everything with one command
- **Versioning**: Control provider versions

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│         NGINX Ingress Controller            │
│         (aigen.local / localhost)           │
└──────────────────┬──────────────────────────┘
                   │
         ┌─────────▼─────────┐
         │  aigen-service    │ (ClusterIP:8000)
         └─────────┬─────────┘
                   │
         ┌─────────▼─────────┐
         │   Django Backend  │
         │   (Deployment)    │
         │   - ConfigMap     │
         │   - Secret        │
         └─────────┬─────────┘
                   │
         ┌─────────▼─────────┐
         │ postgres-service  │ (Headless)
         └─────────┬─────────┘
                   │
         ┌─────────▼─────────┐
         │   PostgreSQL 17   │
         │   (StatefulSet)   │
         │   + PVC (1Gi)     │
         └───────────────────┘
```

**Namespace:** `aigen`  
**Storage:** PersistentVolumeClaim (ReadWriteOnce)  
**Networking:** ClusterIP + Headless Service + Ingress  
**TLS:** Enabled (self-signed certificate)

---

## ⚙️ Prerequisites

### Required Software
- Docker
- Minikube
- kubectl
- Terraform
- Bash

### Verify Installation
```bash
docker --version
minikube version
kubectl version --client
terraform version
```

---

## 🚀 Quick Start (Recommended)

### 1) Clone repository
```bash
git clone https://github.com/luis-barbara/Kubernetes-Infra-with-Terraform.git
cd Kubernetes-Infra-with-Terraform
```

### 2) Configure credentials
Edit `terraform/terraform.tfvars`:
```hcl
postgres_password = "your-secure-password"
openai_api_key    = "sk-your-openai-key"
```

### 3) Automated deployment
```bash
make quickstart
```

This will:
- Initialize Terraform
- Build Docker image (`k8s:latest`)
- Deploy infrastructure with Terraform
- Run validation tests
- Start HTTPS port-forward automatically

Access:
- **HTTPS:** https://localhost:8443 (accept self-signed certificate)
- **HTTP:**  http://localhost:8000 (run `make http`)

---

## 🧰 Useful Commands

Run steps manually:
```bash
make init
make build
make apply
make test
make https
make http
```

Destroy everything:
```bash
make destroy
```

---

## 📁 Project Structure

```
kubernetes-infra-with-terraform/
├── README.md
├── Makefile
├── .gitignore
├── terraform/
│   ├── providers.tf
│   ├── cluster.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── namespace.tf
│   ├── pvc.tf
│   ├── database.tf
│   ├── backend.tf
│   ├── ingress.tf
│   └── terraform.tfvars
├── scripts/
│   ├── init.sh
│   ├── apply.sh
│   ├── test.sh
│   ├── destroy.sh
│   ├── build.sh
│   ├── load-image.sh
│   └── port-forward-https.sh
├── k8s/
│   └── ingress/
│       └── certs/
│           ├── tls.crt
│           └── tls.key
└── AI-IMAGE-GENERATOR/
    └── (Django application)
```

---

## 🔧 Configuration

### Main Variables (`terraform/variables.tf`)

| Variable | Description | Default |
|----------|-------------|---------|
| `cluster_name` | Cluster name | `aigen-cluster` |
| `cluster_nodes` | Number of nodes | `1` |
| `backend_image` | Django Docker image | `k8s:latest` |
| `postgres_db` | Database name | `dali_db` |
| `postgres_username` | DB username | (required) |
| `postgres_password` | DB password | (required) |
| `openai_api_key` | OpenAI API Key | (required) |
| `ingress_host` | Ingress hostname | `aigen.local` |
| `enable_tls` | Enable TLS | `true` |

---

## 🧪 Testing

Run automated tests:
```bash
make test
```

Manual checks:
```bash
kubectl get all -n aigen
kubectl get pods -n aigen
kubectl get ingress -n aigen
kubectl get pvc -n aigen
```

---

## 🗑️ Destroy Environment

Destroy everything:
```bash
make destroy
```

---

## ⚠️ Known Limitations

1. **Local image on Minikube**
   - Requires loading the image into Minikube (`minikube image load k8s:latest`)
   - Recommended `imagePullPolicy = IfNotPresent`

2. **Self-signed TLS**
   - Browser will show warning (expected)

3. **Windows/WSL**
   - Best access method is port-forward (`make https` or `make http`)

4. **Data removed on destroy**
   - PVC data is lost after `terraform destroy`

---

## 🔍 Troubleshooting

### Pods not starting
```bash
kubectl get pods -n aigen
kubectl describe pod -n aigen <pod-name>
kubectl logs -n aigen <pod-name>
```

### Ingress not working
```bash
kubectl get ingress -n aigen
kubectl get svc -n ingress-nginx
```

### PostgreSQL connection issues
```bash
kubectl exec -it -n aigen postgres-0 -- pg_isready
kubectl logs -n aigen -l app=postgres
```

---

## 📚 References

- Terraform Kubernetes Provider: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
- Minikube Documentation: https://minikube.sigs.k8s.io/docs/
- Kubernetes StatefulSets: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
- NGINX Ingress Controller: https://kubernetes.github.io/ingress-nginx/

---

## 📝 Important Notes

- **DO NOT COMMIT** `terraform/terraform.tfvars` (contains credentials)
- Add to `.gitignore`:
  ```
  terraform/terraform.tfvars
  *.tfstate
  *.tfstate.backup
  .terraform/
  *.tfplan
  cluster.plan
  k8s.plan
  ```

---

## 👤 Author

Luís Bárbara — Practical Exercise: Kubernetes Infrastructure with Terraform

---

## 📄 License

This project is for educational purposes only.
