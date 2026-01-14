resource "minikube_cluster" "mycluster" {
    cluster_name = var.client
    nodes = 3
  
}

resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = "app"
  }
}