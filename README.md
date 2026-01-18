# Kubernetes 3-Tier Infrastructure with Terraform

AI Image Generator application deployed on Kubernetes using Terraform Infrastructure as Code.

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Project Structure](#project-structure)

---
- **Database**: PostgreSQL 17 Alpine
- **Orchestration**: Kubernetes (Minikube)
- **IaC**: Terraform

### What was **REUSED**:
✅ Same Django application (AI Image Generator)  

🔄 **Secrets managed via `terraform.tfvars`** (not hardcoded)  
- ✅ **State management**: Terraform tracks what exists

## 🚀 Quick Start

### 1️⃣ Clone Repository
```bash
- ✅ **Variables and outputs**: Dynamic configuration
- ✅ **Easy destroy**: Remove everything with one command
```

### 2️⃣ Configure Credentials

Edit `terraform/terraform.tfvars`:
```hcl
- ✅ **Versioning**: Control provider versions

```

### 3️⃣ Deploy Everything (Automático)

```bash
---
```
Esse comando irá:
- Inicializar o Terraform
- Buildar a imagem Docker
- Aplicar a infraestrutura
- Rodar os testes
- Fazer o port-forward HTTPS automaticamente

Ao final, acesse:
- HTTPS: https://localhost:8443 (aceite o certificado self-signed)
- HTTP:  http://localhost:8000 (use `make http` se quiser expor HTTP)

---

### Comandos Individuais (Avançado)

Se preferir executar etapas separadas:

```bash

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

**Namespace**: `aigen`  
**Storage**: PersistentVolumeClaim (ReadWriteOnce)  
**Networking**: ClusterIP + Headless Service + Ingress  

---

## ⚙️ Prerequisites

### Required Software:
- [Docker](https://docs.docker.com/get-docker/) >= 20.x
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) >= 1.30
- [kubectl](https://kubernetes.io/docs/tasks/tools/) >= 1.28
- [Terraform](https://www.terraform.io/downloads) >= 1.0
- Bash shell

### Verify Installation:
```bash
docker --version
minikube version
kubectl version --client
terraform version
```

---

## 🚀 Quick Start

### 1️⃣ Clone Repository
```bash
git clone 
cd k8s-3tier-terraform
```

### 2️⃣ Configure Credentials

Edit `terraform/terraform.tfvars`:
```hcl
postgres_password = "your-secure-password"
openai_api_key    = "sk-your-openai-key"
```

### 3️⃣ Build Docker Image

```bash
cd AI-IMAGE-GENERATOR
docker build -t k8s:latest .
cd ..
```

### 4️⃣ Deploy Infrastructure

```bash
chmod +x scripts/*.sh
./scripts/init.sh
./scripts/apply.sh
```

### 5️⃣ Access Application

**Option 1 - Port Forward (Recommended for Windows/WSL):**
```bash
kubectl port-forward -n aigen svc/aigen-service 8000:8000
```
Open: `http://localhost:8000`

**Option 2 - HTTPS via Ingress:**
```bash
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8443:443
```
Open: `https://localhost:8443`

**Option 3 - Direct Access (Linux/Mac):**
```bash
echo "$(minikube -p aigen-cluster ip) aigen.local" | sudo tee -a /etc/hosts
```
Open: `https://aigen.local`

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
│   ├── port-forward.sh
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

### Main Variables (terraform/variables.tf)

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

## 💻 Usage

### Terraform Commands

```bash
cd terraform

# Initialize
terraform init

# Plan
terraform plan -out=cluster.plan

# Apply
terraform apply cluster.plan

# Show outputs
terraform output

# Destroy
terraform destroy
```

### Kubernetes Commands

```bash
# View all resources
kubectl get all -n aigen

# View pods
kubectl get pods -n aigen

# Backend logs
kubectl logs -f -n aigen -l app=aigen

# PostgreSQL logs
kubectl logs -f -n aigen -l app=postgres

# Access PostgreSQL
kubectl exec -it -n aigen postgres-0 -- psql -U postgres -d dali_db

# Port-forward
kubectl port-forward -n aigen svc/aigen-service 8000:8000
```

---

## 🧪 Testing

### Automated Test
```bash
./scripts/test.sh
```

### Manual Tests

**1. Check cluster:**
```bash
minikube status -p aigen-cluster
```

**2. Check pods:**
```bash
kubectl get pods -n aigen -w
```

**3. Test PostgreSQL:**
```bash
POD=$(kubectl get pod -n aigen -l app=postgres -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n aigen $POD -- psql -U postgres -c '\l'
```

**4. Test API:**
```bash
curl -I http://localhost:8000
```

---

## 🗑️ Destroy Environment

### Method 1: Automated Script (Recommended)
```bash
./scripts/destroy.sh
```

### Method 2: Manual Terraform
```bash
cd terraform
terraform destroy -auto-approve
```

### Method 3: Complete Cleanup
```bash
terraform destroy -auto-approve
minikube delete --all
docker system prune -a
```

---

## ⚠️ Known Limitations

1. **Docker Image**: `imagePullPolicy: Never` only works with local images
   - **Solution**: Publish to Docker Hub or use `minikube image load`

2. **Ingress DNS**: `aigen.local` requires `/etc/hosts` entry
   - **Solution**: Add manually or use port-forward

3. **Self-Signed TLS**: Certificates not trusted by browsers
   - **Solution**: Accept security warning or use Let's Encrypt for production

4. **StatefulSet Node Selector**: PostgreSQL pinned to specific node
   - **Solution**: Remove `node_selector` for multi-node clusters

5. **Data Persistence**: Data lost when cluster destroyed
   - **Solution**: Manual backup before `terraform destroy`

6. **OpenAI API Key**: Requires valid key to function
   - **Solution**: Get key from https://platform.openai.com/api-keys

7. **Windows/WSL**: Direct Ingress access may not work
   - **Solution**: Use port-forward

---

## 🔍 Troubleshooting

### Pods Not Starting

```bash
kubectl get pods -n aigen
kubectl logs -n aigen 
kubectl describe pod -n aigen 
```

**Common solutions:**
- Check if image exists: `minikube -p aigen-cluster image ls | grep k8s`
- Verify secrets: `kubectl get secrets -n aigen`
- Increase resources in Minikube

### Ingress Not Working

```bash
minikube addons list | grep ingress
minikube addons enable ingress
kubectl get ingress -n aigen
```

### PostgreSQL Connection Issues

```bash
kubectl get svc -n aigen postgres-service
kubectl get pvc -n aigen
kubectl exec -n aigen postgres-0 -- pg_isready
```

### Terraform Errors

```bash
# Recreate state
rm -rf .terraform terraform.tfstate*
terraform init

# Debug
TF_LOG=DEBUG terraform apply
```

---

## 📚 References

- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Kubernetes StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

---

## 📝 Important Notes

1. **DO NOT COMMIT** `terraform.tfvars` to Git (contains credentials)
2. **Add to `.gitignore`**:
   ```
   terraform.tfvars
   *.tfstate
   *.tfstate.backup
   .terraform/
   ```
3. **For production**: Use remote backend (S3, GCS) for Terraform state
4. **Security**: Use secrets manager (Vault, AWS Secrets Manager)

---

## 👤 Author

Luís Bárbara - Practical Exercise – Kubernetes Infrastructure with Terraform

---

## 📄 License

This project is for educational purposes.
