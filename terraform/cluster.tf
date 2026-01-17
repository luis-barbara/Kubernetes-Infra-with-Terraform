# Minikube Cluster
resource "minikube_cluster" "mycluster" {
  cluster_name = var.cluster_name  
  driver       = "docker"          
  nodes        = var.cluster_nodes
  cpus         = var.cluster_cpus     
  memory       = var.cluster_memory  
  
 
  addons = [
    "default-storageclass",
    "storage-provisioner",
    "ingress"  
  ]
}