terraform {
    required_providers {
      kubernetes = {
        source = "hashicorp/kubernetes"
        version = "=1.13.3"
      }
    }
}

provider "kubernetes" {

}

resource "kubernetes_namespace" "bookstore" {
  metadata {
    name = "${var.ENVIRONMENT}-${var.namespace}"
    annotations = {
      name        = var.namespace
      environment = var.ENVIRONMENT
    }
  }
}

module "bookstore" {
  source = "./bookstore"

  app_namespace = kubernetes_namespace.bookstore.metadata.0.name
  app_name      = var.app_name
  app_port      = 8080

  container_registry = var.container_registry

  app_container = {
    image   = var.app_container
    version = var.app_container_version
  }

  database_container = {
    image   = var.database_container
    version = var.database_container_version
  }
}

output website_url {
  value       = "http://${module.bookstore.app_service_ip}"
  description = "Application Service URL"
}

output app_service_name {
  value       = module.bookstore.app_service_name
  description = "Application Service name"
}