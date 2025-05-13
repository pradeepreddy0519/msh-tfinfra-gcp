# Random suffix for bucket name to ensure uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Enable required APIs
resource "google_project_service" "storage_api" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

# Service account for bucket operations
resource "google_service_account" "bucket_sa" {
  account_id   = "${var.bucket_name}-sa"
  display_name = "Service Account for Storage Bucket"
}

# Service account used for authenticate with Google Cloud and are granted specific roles to access resources
resource "google_project_iam_member" "bucket_sa_roles" {
  for_each = toset([
    "roles/storage.objectViewer", # Read-only access to objects in GCS
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.bucket_sa.email}"
}

# Storage bucket
resource "google_storage_bucket" "bucket" {
  name                        = "${var.bucket_name}-${var.project_id}-${random_id.bucket_suffix.hex}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy = true

  depends_on = [google_project_service.storage_api]
}

# Sample file upload as a storage object
resource "google_storage_bucket_object" "sample_object" {
  name   = "${var.bucket_name}-object"
  bucket = google_storage_bucket.bucket.name
  source = var.source_archive_object # Ensure this file exists locally
  content_type = "application/zip"

  depends_on = [google_storage_bucket.bucket]
}

# IAM policy to make the object publicly readable (optional)
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}