# Variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "source_archive_object" {
  type = string
}

variable "bucket_name" {
  description = "Base name of the storage bucket"
  type        = string
}