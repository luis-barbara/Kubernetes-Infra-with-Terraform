# Minikube Cluster
resource "minikube_cluster" "mycluster" {
  cluster_name = var.client
  nodes        = var.cluster_nodes
}


