
# Cluster Config
variable "cluster_name" {
  description = "Minikube cluster name"
  type        = string
  default     = "aigen-cluster"
}

variable "cluster_nodes" {
  description = "Number of nodes in the Minikube cluster"
  type        = number
  default     = 1
}

variable "cluster_cpus" {
  description = "CPUs per node"
  type        = number
  default     = 2
}

variable "cluster_memory" {
  description = "Memory per node (MB)"
  type        = string
  default     = "4096"
}


# Environment
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "aigen"
}


# Backnd Dkango
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


# Database Configuration 
variable "postgres_image" {
  description = "PostgreSQL container image"
  type        = string
  default     = "postgres:17-alpine"
}

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
  sensitive   = true
}

variable "storage_size" {
  description = "Storage size for PostgreSQL PVC"
  type        = string
  default     = "1Gi"
}


# Openai API
variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  sensitive   = true
}


# Ingress Configuration
variable "ingress_host" {
  description = "Ingress host for the application"
  type        = string
  default     = "aigen.local"
}

variable "enable_tls" {
  description = "Enable TLS for ingress"
  type        = bool
  default     = false
}