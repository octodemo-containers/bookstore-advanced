terraform {

}

provider "google" {
    version                 = "=3.40"
    project                 = var.gcp_project
}

module "gcp_cloudrun" {
    source                  = "github.com/octodemo-db/gcp-cloudrun?ref=main"

    gcp_project             = var.gcp_project
    gcp_application_name    = "github-bookstore-${var.ENVIRONMENT}"
    gcr_image               = var.container_image
    gcr_image_tag           = var.container_tag
    container_port          = 8080
}

output "website_url" {
    value                   = module.gcp_cloudrun.url
}