# PostgreSQL Database Resources

# Secret for PostgreSQL
resource "kubernetes_secret_v1" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
  }

  data = {
    POSTGRES_USER     = base64encode(var.postgres_username)
    POSTGRES_PASSWORD = base64encode(var.postgres_password)
    POSTGRES_DB       = base64encode(var.postgres_db)
  }

  type = "Opaque"
}

# PostgreSQL Service (Headless for StatefulSet)
resource "kubernetes_service_v1" "postgres_service" {
  metadata {
    name      = "postgres-service"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name

    labels = {
      app = "postgres"
    }
  }

  spec {
    type       = "ClusterIP"
    cluster_ip = "None" # Headless service

    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
      name        = "postgres"
    }
  }
}

# PostgreSQL StatefulSet
resource "kubernetes_stateful_set_v1" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
    labels = {
      app         = "postgres"
      environment = var.environment
    }
  }

  spec {
    service_name = kubernetes_service_v1.postgres_service.metadata[0].name
    replicas     = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {


        container {
            name  = "postgres"
            image = var.postgres_image
            image_pull_policy = "IfNotPresent"

          port {
            container_port = 5432
          }

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres_secret.metadata[0].name
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres_secret.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres_secret.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
            sub_path   = "postgres"
          }
        }

        volume {
          name = "postgres-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_persistent_volume_claim_v1.postgres_pvc,
    kubernetes_secret_v1.postgres_secret,
    kubernetes_service_v1.postgres_service
  ]
}
