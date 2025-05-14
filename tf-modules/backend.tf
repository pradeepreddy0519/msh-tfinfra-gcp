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
  backend "gcs" {
    bucket = ""
    prefix = "terraform/state"
  }

  required_version = ">= 1.3.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}
