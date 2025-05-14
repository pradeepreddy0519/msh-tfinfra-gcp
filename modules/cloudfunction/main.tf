# Enable required APIs
resource "google_project_service" "required_apis" {
  project = var.project_id
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com"
  ])
  service            = each.key
  disable_on_destroy = false
}

# Service account used for authenticate with Google Cloud and are granted specific roles to access resources
resource "google_service_account" "function_sa" {
  account_id   = "${var.function_name}-sa"
  display_name = "Service Account for ${var.function_name}"
}

# IAM roles for service account
resource "google_project_iam_member" "function_sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/cloudfunctions.developer"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}

# Cloud Function v1
resource "google_cloudfunctions_function" "function" {
  name        = var.function_name
  description = "HTTP-triggered Cloud Function v1"
  runtime     = var.runtime
  entry_point = var.entry_point
  region      = var.region

  source_archive_bucket = var.bucket_name
  source_archive_object = var.object_name

  available_memory_mb   = 256
  timeout               = 60
  service_account_email = google_service_account.function_sa.email
  trigger_http          = true

  environment_variables = {
    ENV = var.env
  }

  depends_on = [
    google_project_service.required_apis,
  ]
}

# IAM policy to allow public HTTP access to Cloud Function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project_id
  region         = var.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}
