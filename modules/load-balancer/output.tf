output "load_balancer_ip" {
  description = "The external IP address of the load balancer"
  value       = google_compute_global_forwarding_rule.http_forwarding_rule.ip_address
}

output "url_map_name" {
  description = "Name of the URL map"
  value       = google_compute_url_map.url_map.name
}

output "neg_name" {
  description = "Name of the Serverless NEG"
  value       = google_compute_region_network_endpoint_group.function_neg.name
}
