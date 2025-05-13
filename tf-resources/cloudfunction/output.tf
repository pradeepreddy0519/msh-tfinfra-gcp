output "function_name" {
  description = "Name of the deployed Cloud Function"
  value       = google_cloudfunctions_function.function.name
}

output "function_url" {
  description = "The HTTPS endpoint of the deployed Cloud Function"
  value       = google_cloudfunctions_function.function.https_trigger_url
}

output "service_account_email" {
  description = "Email of the service account used by the function"
  value       = google_service_account.function_sa.email
}

output "region" {
  description = "Region where the Cloud Function is deployed"
  value       = google_cloudfunctions_function.function.region
}
