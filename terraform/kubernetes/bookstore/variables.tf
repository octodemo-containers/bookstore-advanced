variable "app_namespace" {
  type = string
}

variable "app_name" {
  default = "bookstore"
  type = string
}

variable "app_port" {
  default = 8080
  type = number
}

variable "database_name" {
  default = "bookstore"
  type = string
}

variable "database_port" {
  default = 5432
  type = number
}

variable "container_registry" {
  type = string
}

variable "app_container" {
  type = object({
    image = string
    version = string
  })
}

variable "database_container" {
  type = object({
    image = string
    version = string
  })
}

locals {
    db_name = "${var.app_name}-db"
}