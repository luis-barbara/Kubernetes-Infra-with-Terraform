# TLS Secret for HTTPS

resource "kubernetes_secret_v1" "tls_secret" {
  count = var.enable_tls ? 1 : 0  

  metadata {
    name      = "aigen-tls-secret"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = filebase64("${path.module}/../k8s/ingress/certs/tls.crt")
    "tls.key" = filebase64("${path.module}/../k8s/ingress/certs/tls.key")
  }
}

# Ingress resource for external access
resource "kubernetes_ingress_v1" "aigen_ingress" {
  metadata {
    name      = "aigen-ingress"
    namespace = kubernetes_namespace_v1.aigen.metadata[0].name

    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    ingress_class_name = "nginx"

    dynamic "tls" {
      for_each = var.enable_tls ? [1] : []
      content {
        hosts = [
          var.ingress_host,
          "localhost"
        ]
        secret_name = "aigen-tls-secret"
      }
    }

    rule {
      host = var.ingress_host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.aigen_service.metadata[0].name
              port {
                number = 8000
              }
            }
          }
        }
      }
    }

    rule {
      host = "localhost"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.aigen_service.metadata[0].name
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_v1.aigen_service
  ]
}