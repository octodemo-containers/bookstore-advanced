resource "kubernetes_secret" "database" {
  metadata {
    name      = "bookstore-db-credentials"
    namespace = var.app_namespace
  }
  type = "Opaque"
  // TODO randomize these
  data = {
    user     = "YWRtaW4K"
    password = "cGxlYXNlY2hhbmdlbWU="
  }
}