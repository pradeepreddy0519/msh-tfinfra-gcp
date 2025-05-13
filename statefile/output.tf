output "bucket" {
    value = google_storage_bucket.state.url
}

output "project_name" {
  value = "project"
}

output "state_bucket_name" {
  value = google_storage_bucket.state.name
}