resource "kubernetes_service" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
  }

  spec {
    selector = {
      app = var.app_name
    }

    type = "LoadBalancer"

    port {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = var.app_port
    }
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = var.app_namespace
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = "bookstore"
          image = "${var.container_registry}/${var.app_container.image}:${var.app_container.version}"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "DATABASE_URL"
            value = "jdbc:postgresql://${local.db_name}:${var.database_port}/${var.database_name}"
          }

          env {
            name = "DATABASE_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database.metadata.0.name
                key  = "user"
              }
            }
          }

          env {
            name = "DATABASE_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database.metadata.0.name
                key  = "password"
              }
            }
          }

          env {
            name = "DATABASE_RETRIES"
            value = "20"
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "0.25"
              memory = "250Mi"
            }
          }
        }

        restart_policy                   = "Always"
        termination_grace_period_seconds = 5
      }
    }
  }
  depends_on = [kubernetes_service.database]
}

output app_service_ip {
  value = tostring(kubernetes_service.app.load_balancer_ingress.0.ip)
  description = "Application Service IP Address"
}

output app_service_name {
  value = kubernetes_service.app.metadata.0.name
  description = "Application Service name"
}
