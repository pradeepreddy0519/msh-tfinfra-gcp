variable "project_id" {
  type = string
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "bucket_name" {
  description = "The name of the GCS bucket to create"
  type        = string
}