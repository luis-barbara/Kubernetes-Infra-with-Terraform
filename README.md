# Kubernetes 3-Tier Web Application

A complete 3-tier web application deployed on Kubernetes using Minikube, featuring a Django backend with templates (frontend), PostgreSQL database, and NGINX Ingress Controller for external access.

## 📋 Table of Contents

- [Application Description](#application-description)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation & Deployment](#installation--deployment)
- [Accessing the Application](#accessing-the-application)
- [Testing](#testing)
- [Management Commands](#management-commands)
- [Kubernetes Resources](#kubernetes-resources)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)

---

## 📖 Application Description

This is an **AI Image Generator** application built with Django that demonstrates a complete 3-tier architecture deployed on Kubernetes:

- **Frontend Tier**: Django Templates (HTML/CSS) serving the user interface
- **Backend Tier**: Django REST application with business logic
- **Database Tier**: PostgreSQL database for persistent data storage

The application allows users to create and manage AI-generated character images with various customization options.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    External Access                       │
│              https://localhost:8443                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │  NGINX Ingress        │
         │  Controller           │
         │  (TLS Termination)    │
         └───────────┬───────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │  Frontend + Backend   │
         │  (Django)             │
         │  - Templates (HTML)   │
         │  - REST API           │
         │  - Business Logic     │
         │  Port: 8000           │
         └───────────┬───────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │  Database             │
         │  (PostgreSQL)         │
         │  - Persistent Storage │
         │  - StatefulSet        │
         │  Port: 5432           │
         └───────────────────────┘
```

### Kubernetes Components:

- **Namespace**: `aigen` - Isolated environment for all resources
- **Ingress**: Routes external HTTPS traffic to the Django service
- **Services**: 
  - `aigen-service` - Exposes Django application (ClusterIP)
  - `postgres-service` - Exposes PostgreSQL database (ClusterIP)
- **Deployments**: `aigen-deployment` - Manages Django pods
- **StatefulSet**: `postgres-statefulset` - Manages PostgreSQL with persistent storage
- **ConfigMap**: `django-config` - Application configuration
- **Secrets**: 
  - `django-secret` - Django secret key
  - `postgres-secret` - Database credentials
  - `aigen-tls-secret` - TLS certificates
- **PersistentVolumeClaim**: `postgres-pvc` - Persistent storage for database

---

## 🛠️ Technologies Used

- **Kubernetes**: Minikube (Local cluster)
- **Container Runtime**: Docker
- **Ingress Controller**: NGINX Ingress Controller
- **Backend Framework**: Django 4.x (Python)
- **Database**: PostgreSQL 15
- **Frontend**: Django Templates (HTML/CSS)
- **Automation**: Bash scripts + Makefile

---

## ✅ Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** - [Install Docker](https://docs.docker.com/get-docker/)
- **Minikube** - [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)
- **kubectl** - [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
- **Make** (optional but recommended)
- **Git**

Verify installations:
```bash
docker --version
minikube version
kubectl version --client
make --version
```

---

## 📁 Project Structure

```
Kubernetes_3-Tier_Web/
├── README.md                          # This file
├── Makefile                           # Quick commands
├── AI-IMAGE-GENERATOR/                # Django application source code
│   ├── Dockerfile                     # Docker image definition
│   ├── manage.py                      # Django management script
│   ├── requirements.txt               # Python dependencies
│   ├── dali/                          # Django project settings
│   └── characters/                    # Main Django app
├── k8s/                               # Kubernetes manifests
│   ├── namespaces/
│   │   └── namespaces.yaml           # Namespace definition
│   ├── backend-django-templates/      # Backend resources
│   │   ├── deployment.yaml           # Django deployment
│   │   ├── service.yaml              # Django service
│   │   ├── configmap.yaml            # Application config
│   │   └── secret.yaml               # Django secrets
│   ├── database/                      # Database resources
│   │   ├── statefulset.yaml          # PostgreSQL StatefulSet
│   │   ├── service.yaml              # Database service
│   │   ├── pvc.yaml                  # Persistent volume claim
│   │   └── secret.yaml               # Database credentials
│   └── ingress/                       # Ingress resources
│       ├── ingress.yaml              # Ingress rules
│       └── certs/                    # TLS certificates (generated)
└── scripts/                           # Automation scripts
    ├── setup.sh                       # Initial setup
    ├── build.sh                       # Build Docker image
    ├── deploy.sh                      # Deploy application
    ├── test.sh                        # Run tests
    ├── port-forward.sh               # Access application
    ├── status.sh                      # Check status
    ├── logs.sh                        # View logs
    ├── restart.sh                     # Restart pods
    ├── migrate.sh                     # Run migrations
    └── destroy.sh                     # Cleanup resources
```

---

## 🚀 Installation & Deployment

### Quick Start (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd Kubernetes_3-Tier_Web

# Start Minikube
minikube start

# Deploy everything with one command
make quickstart
```

This will:
1. ✅ Create namespace and secrets
2. ✅ Install NGINX Ingress Controller
3. ✅ Start Minikube tunnel
4. ✅ Build Docker image
5. ✅ Deploy database and backend
6. ✅ Configure Ingress
7. ✅ Wait for all pods to be ready
8. ✅ Run validation tests
9. ✅ Start port-forward for access

### Manual Step-by-Step

If you prefer manual control:

```bash
# 1. Start Minikube
minikube start

# 2. Initial setup (namespace, secrets, ingress controller)
make setup
# or: ./scripts/setup.sh

# 3. Build Docker image in Minikube
make build
# or: ./scripts/build.sh

# 4. Deploy application
make deploy
# or: ./scripts/deploy.sh

# 5. Start port-forward to access the application
make start
# or: ./scripts/port-forward.sh
```

---

## 🌐 Accessing the Application

Once deployed, access the application at:

```
https://localhost:8443
```

**Note**: You'll see a certificate warning because we use self-signed certificates. Click "Advanced" → "Proceed to localhost" to continue.

### Alternative Access Methods

1. **Via NodePort** (without port-forward):
   ```bash
   # Get Minikube IP
   minikube ip
   
   # Access via NodePort
   curl -k https://$(minikube ip):32507 -H "Host: aigen.local"
   ```

2. **Inside the cluster**:
   ```bash
   kubectl exec -it <pod-name> -n aigen -- curl http://aigen-service:8000
   ```

---

## 🧪 Testing

Run the automated test suite to validate the deployment:

```bash
make test
# or: ./scripts/test.sh
```

The test script validates:
- ✅ Minikube is running
- ✅ Namespace exists
- ✅ All pods are running
- ✅ All services exist
- ✅ Ingress is configured
- ✅ Secrets and ConfigMaps exist
- ✅ PersistentVolumeClaim is bound
- ✅ Database connectivity
- ✅ Backend HTTP responses
- ✅ Ingress Controller is running
- ✅ End-to-end connectivity

---

## 📝 Management Commands

### Using Makefile (Recommended)

```bash
make help           # Show all available commands
make setup          # Initial setup
make build          # Build Docker image
make deploy         # Deploy application
make start          # Start port-forward
make stop           # Stop port-forward
make status         # Show cluster status
make logs-backend   # View Django logs
make logs-db        # View PostgreSQL logs
make restart        # Restart all pods
make migrate        # Run Django migrations
make test           # Run validation tests
make destroy        # Remove all resources
make quickstart     # Complete setup + deployment + access
```

### Using Scripts Directly

```bash
./scripts/setup.sh          # Initial setup
./scripts/build.sh          # Build Docker image
./scripts/deploy.sh         # Deploy application
./scripts/port-forward.sh   # Start port-forward
./scripts/status.sh         # Show cluster status
./scripts/logs.sh backend   # View Django logs
./scripts/logs.sh db        # View PostgreSQL logs
./scripts/restart.sh        # Restart pods
./scripts/migrate.sh        # Run migrations
./scripts/test.sh           # Run tests
./scripts/destroy.sh        # Cleanup
```

---

## 📦 Kubernetes Resources

### Deployments
- **aigen-deployment**: Runs Django application (1 replica, can scale)

### StatefulSets
- **postgres-statefulset**: Runs PostgreSQL with persistent storage (1 replica)

### Services
- **aigen-service**: ClusterIP service for Django (port 8000)
- **postgres-service**: ClusterIP service for PostgreSQL (port 5432)

### ConfigMaps
- **django-config**: Application configuration (database host, settings module)

### Secrets
- **django-secret**: Django SECRET_KEY
- **postgres-secret**: Database credentials (username, password, database name)
- **aigen-tls-secret**: TLS certificate and key for HTTPS

### PersistentVolumeClaims
- **postgres-pvc**: 1Gi storage for PostgreSQL data

### Ingress
- **aigen-ingress**: Routes external traffic to Django service
  - Hosts: `aigen.local`, `localhost`
  - TLS enabled
  - Path: `/` → `aigen-service:8000`

---

## 🔧 Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl get pods -n aigen

# View pod details
kubectl describe pod <pod-name> -n aigen

# View pod logs
kubectl logs <pod-name> -n aigen
```

### Database connection issues

```bash
# Check database pod
kubectl logs -n aigen -l app=postgres

# Test database connection
kubectl exec -it <postgres-pod> -n aigen -- psql -U postgres
```

### Application not accessible

```bash
# Verify port-forward is running
ps aux | grep "kubectl port-forward"

# Check ingress status
kubectl get ingress -n aigen

# Verify services
kubectl get svc -n aigen
```

### Image pull errors

```bash
# Rebuild image in Minikube
eval $(minikube docker-env)
docker build -t k8s:latest ./AI-IMAGE-GENERATOR/

# Verify image exists
docker images | grep k8s
```

---

## 🗑️ Cleanup

To remove all resources:

```bash
make destroy
# or: ./scripts/destroy.sh
```

This will:
- Stop port-forwards
- Delete Ingress
- Delete backend deployment
- Delete database StatefulSet
- Delete namespace (which removes all resources inside)
- Stop Minikube tunnel

To also stop Minikube:
```bash
minikube stop
minikube delete
```

---

## 📚 Additional Information

### Scaling the Application

```bash
# Scale Django deployment
kubectl scale deployment aigen-deployment -n aigen --replicas=3

# Verify
kubectl get pods -n aigen
```

### Updating the Application

```bash
# Rebuild image
make build

# Restart deployment to use new image
make restart
```

### Running Django Commands

```bash
# Get pod name
POD=$(kubectl get pod -n aigen -l app=aigen -o jsonpath="{.items[0].metadata.name}")

# Run migrations
kubectl exec -it $POD -n aigen -- python manage.py migrate

# Create superuser
kubectl exec -it $POD -n aigen -- python manage.py createsuperuser

# Django shell
kubectl exec -it $POD -n aigen -- python manage.py shell
```

---

## 👨‍💻 Author

Created for Kubernetes Module Assignment

## 📄 License

See LICENSE file for details
