terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Use latest 5.x version
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5" # Or latest 3.x
    }
  }

  required_version = ">= 1.3.0"
}


provider "google" {
  project = var.project_id
  region  = var.region
}

# terraform bucket creation with versioning enabled
resource "google_storage_bucket" "state" {
  name     = var.bucket_name
  location = "US"
  force_destroy = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}