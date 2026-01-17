terraform {
  required_version = ">= 1.0"
  
  required_providers {
    minikube = {
      source  = "scott-the-programmer/minikube"
      version = "~> 0.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}


provider "minikube" {
  kubernetes_version = "v1.30.2"
}


provider "kubernetes" {
  host = minikube_cluster.mycluster.host

  client_certificate     = minikube_cluster.mycluster.client_certificate
  client_key             = minikube_cluster.mycluster.client_key
  cluster_ca_certificate = minikube_cluster.mycluster.cluster_ca_certificate
}