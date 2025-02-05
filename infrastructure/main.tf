terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = local.credentials_file
  project     = var.gcp_project
  region      = var.region
}