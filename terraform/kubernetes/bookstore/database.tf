resource "kubernetes_persistent_volume_claim" "database_volume_claim" {
  metadata {
    name = "${local.db_name}-pv-claim"
    namespace = var.app_namespace
  }

  spec {
    resources {
      requests = {
        storage = "5Gi"
      }
    }

    access_modes = ["ReadWriteOnce"]
  }
}

resource "kubernetes_service" "database" {
  metadata {
    name      = local.db_name
    namespace = var.app_namespace
  }

  spec {
    selector = {
      service = local.db_name
    }

    type = "ClusterIP"

    port {
      name        = "db"
      port        = var.database_port
      protocol    = "TCP"
      target_port = var.database_port
    }
  }
}

resource "kubernetes_deployment" "database" {
  metadata {
    name      = local.db_name
    namespace = var.app_namespace

    labels = {
      service = local.db_name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        service = local.db_name
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          service = local.db_name
        }
      }

      spec {
        container {
          name  = "bookstore-database"
          image = "${var.container_registry}/${var.database_container.image}:${var.database_container.version}"
          image_pull_policy = "IfNotPresent"        

          env {
            name = "POSTGRES_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database.metadata.0.name
                key  = "user"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.database.metadata.0.name
                key  = "password"
              }
            }
          }

          env {
            name = "POSTGRES_DB"
            value = var.database_name
          }

          volume_mount {
            name = "${local.db_name}-volume"
            mount_path = "/var/lib/postgresql/data"
            sub_path = "postgres"
          }
        }

        volume {
          name = "${local.db_name}-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.database_volume_claim.metadata.0.name
          }
        }

        restart_policy                   = "Always"
        termination_grace_period_seconds = 5
      }
    }
  }
}