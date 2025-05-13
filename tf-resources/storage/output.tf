# Outputs
output "bucket_name" {
  description = "Name of the storage bucket"
  value       = google_storage_bucket.bucket.name
}

output "object_name" {
  description = "Name of the uploaded object"
  value       = google_storage_bucket_object.sample_object.name
}

output "object_url" {
  description = "Public URL of the uploaded object"
  value       = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.sample_object.name}"
}