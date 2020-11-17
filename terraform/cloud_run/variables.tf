variable "gcp_project" {
    type            = string
    description     = "The GCP Project ID"
}

variable "container_image" {
    type            = string
    description     = "The name of the container to be deployed"
    default         = "octodemo-db/bookstore"
}

variable "container_tag" {
    type            = string
    description     = "The version tag of the container to be deployed"
    default         = "latest"
}

variable "ENVIRONMENT" {
    type            = string
    description     = "The environment being deployed to"
    default         = "dev"
}