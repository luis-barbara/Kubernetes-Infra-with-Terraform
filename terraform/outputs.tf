# Outputs for the Kubernetes infrastructure


# Cluster Info
output "cluster_name" {
  description = "Minikube cluster name"
  value       = minikube_cluster.mycluster.cluster_name
}

output "cluster_host" {
  description = "Kubernetes cluster host"
  value       = minikube_cluster.mycluster.host
  sensitive   = true 
}


output "minikube_ip" {
  description = "Minikube IP address (add to /etc/hosts)"
  value       = "Run: minikube ip"
}


# Namespaces and services
output "namespace" {
  description = "Application namespace"
  value       = kubernetes_namespace_v1.aigen.metadata[0].name
}

output "backend_service_name" {
  description = "Backend service name"
  value       = kubernetes_service_v1.aigen_service.metadata[0].name
}

output "database_service_name" {
  description = "Database service name"
  value       = kubernetes_service_v1.postgres_service.metadata[0].name
}


# App access
output "ingress_host" {
  description = "Ingress host for external access"
  value       = var.ingress_host
}

output "application_url" {
  description = "Application URL"
  value       = var.enable_tls ? "https://${var.ingress_host}" : "http://${var.ingress_host}"
}

