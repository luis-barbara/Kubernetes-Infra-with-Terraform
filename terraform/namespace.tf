# Namespace for the application
resource "kubernetes_namespace_v1" "aigen" {
  metadata {
    name = var.namespace

    labels = {
      name        = var.namespace
      environment = var.environment
    }
  }
}
