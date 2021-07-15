terraform {
  required_version = ">= 0.13.0"
  required_providers {
    dynatrace = {
      source = "luisr-escobar/dynatrace"
      version = "1.0.2"
    }
    google = {
      version = "3.75.0"
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  credentials = file(var.gcloud_cred_file)
  project     = var.gcloud_project
  region      = join("-", slice(split("-", var.gcloud_zone), 0, 2))
}

provider "dynatrace" {
  dt_cluster_url   = var.dt_cluster_url
  dt_cluster_api_token = var.dt_cluster_api_token
}


# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}
