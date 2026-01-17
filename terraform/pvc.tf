
# PersistentVolumeClaim for PostgreSQL
resource "kubernetes_persistent_volume_claim_v1" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name

    labels = {
      app = "postgres"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.storage_size
      }
    }

  }

 
  depends_on = [
    kubernetes_namespace_v1.aigen
  ]

}