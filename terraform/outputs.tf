# Outputs for the Kubernetes infrastructure

output "cluster_name" {
  description = "Minikube cluster name"
  value       = minikube_cluster.mycluster.cluster_name
}

output "cluster_host" {
  description = "Kubernetes cluster host"
  value       = minikube_cluster.mycluster.host
}

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

output "ingress_host" {
  description = "Ingress host for external access"
  value       = var.ingress_host
}

output "application_url" {
  description = "Application URL"
  value       = "http://${var.ingress_host}"
}
