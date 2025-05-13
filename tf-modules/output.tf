###############################
# GCS BUCKET
###############################
output "bucket_name" {
  description = "The full name of the created GCS bucket"
  value       = module.gcs_bucket.bucket_name
}

# output "uploaded_file_url" {
#   description = "The public URL of the uploaded file"
#   value       = module.gcs_bucket.file_url
# }

################################
# CLOUD Function
################################
output "cloud_function_name" {
  description = "The name of the deployed Cloud Function"
  value       = module.cloud_function.function_name
}

output "cloud_function_url" {
  description = "The public URL of the deployed Cloud Function"
  value       = module.cloud_function.function_url
}

output "cloud_function_service_account" {
  description = "Service account email associated with the Cloud Function"
  value       = module.cloud_function.service_account_email
}

################################
# Load-Balancer
################################
output "lb_ip" {
  value = module.lb.load_balancer_ip
}
