variable "client" {
    description = "client's name"
    type = string
    default = null
}

variable "cluster_nodes" {
  description = "Number of nodes in the Minikube cluster"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Backend Django Variables
variable "backend_image" {
  description = "Docker image for the backend Django application"
  type        = string
  default     = "aigen:latest"
}

variable "backend_image_pull_policy" {
  description = "Image pull policy for backend container"
  type        = string
  default     = "IfNotPresent"
}

variable "backend_replicas" {
  description = "Number of replicas for the backend deployment"
  type        = number
  default     = 1
}

variable "backend_cpu_limit" {
  description = "CPU limit for backend container"
  type        = string
  default     = "500m"
}

variable "backend_memory_limit" {
  description = "Memory limit for backend container"
  type        = string
  default     = "512Mi"
}

variable "backend_cpu_request" {
  description = "CPU request for backend container"
  type        = string
  default     = "250m"
}

variable "backend_memory_request" {
  description = "Memory request for backend container"
  type        = string
  default     = "256Mi"
}

# Django Configuration
variable "django_debug" {
  description = "Django debug mode"
  type        = string
  default     = "False"
}

# Database Variables
variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "dali_db"
}

variable "postgres_host" {
  description = "PostgreSQL service host"
  type        = string
  default     = "postgres-service"
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = string
  default     = "5432"
}

variable "postgres_username" {
  description = "PostgreSQL username"
  type        = string
  default     = "postgres"
  sensitive   = true
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "qwerty"
  sensitive   = true
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  sensitive   = true
}

# Infrastructure Variables
variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "aigen"
}

variable "postgres_image" {
  description = "PostgreSQL container image"
  type        = string
  default     = "postgres:17-alpine"
}

variable "storage_size" {
  description = "Storage size for PostgreSQL PVC"
  type        = string
  default     = "1Gi"
}

variable "ingress_host" {
  description = "Ingress host for the application"
  type        = string
  default     = "aigen.local"
}