# Backend Django App Resources

# ConfigMap for Django configuration
resource "kubernetes_config_map_v1" "django_config" {
  metadata {
    name      = "django-config"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
  }

  data = {
    DJANGO_DEBUG  = var.django_debug
    POSTGRES_DB   = var.postgres_db
    POSTGRES_HOST = var.postgres_host
    POSTGRES_PORT = var.postgres_port
  }
}

# Secret for sensitive Django configuration
resource "kubernetes_secret_v1" "django_secret" {
  metadata {
    name      = "django-secret"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
  }

  data = {
    POSTGRES_USERNAME = var.postgres_username
    POSTGRES_PASSWORD = var.postgres_password
    OPENAI_API_KEY    = var.openai_api_key
  }

  type = "Opaque"
}

# Backend Django Deployment
resource "kubernetes_deployment_v1" "aigen_backend" {
  metadata {
    name      = "aigen"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
    labels = {
      app         = "aigen"
      environment = var.environment
    }
  }

  spec {
    replicas = var.backend_replicas

    selector {
      match_labels = {
        app = "aigen"
      }
    }

    template {
      metadata {
        labels = {
          app = "aigen"
        }
      }

      spec {
        container {
          name              = "k8s"
          image             = var.backend_image
          image_pull_policy = var.backend_image_pull_policy

          port {
            container_port = 8000
          }

          # Environment variables from ConfigMap
          env {
            name = "DJANGO_DEBUG"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.django_config.metadata[0].name
                key  = "DJANGO_DEBUG"
              }
            }
          }

          env {
            name = "POSTGRES_HOST"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.django_config.metadata[0].name
                key  = "POSTGRES_HOST"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.django_config.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }

          env {
            name = "POSTGRES_PORT"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map_v1.django_config.metadata[0].name
                key  = "POSTGRES_PORT"
              }
            }
          }

          # Environment variables from Secret
          env {
            name = "POSTGRES_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.django_secret.metadata[0].name
                key  = "POSTGRES_USERNAME"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.django_secret.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          env {
            name = "OPENAI_API_KEY"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.django_secret.metadata[0].name
                key  = "OPENAI_API_KEY"
              }
            }
          }

          resources {
            limits = {
              cpu    = var.backend_cpu_limit
              memory = var.backend_memory_limit
            }
            requests = {
              cpu    = var.backend_cpu_request
              memory = var.backend_memory_request
            }
          }

         
        }
      }
    }
  }

  depends_on = [
    kubernetes_stateful_set_v1.postgres 
  ]
}

# Backend Service
resource "kubernetes_service_v1" "aigen_service" {
  metadata {
    name      = "aigen-service"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
    labels = {
      app = "aigen"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "aigen"
    }

    port {
      port        = 8000
      target_port = 8000
      protocol    = "TCP"
      name        = "http"
    }
  }

  depends_on = [kubernetes_deployment_v1.aigen_backend]
}