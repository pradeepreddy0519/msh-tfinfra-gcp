# Creates a Serverless NEG in a region to link the Cloud Function to the Load Balancer.
resource "google_compute_region_network_endpoint_group" "function_neg" {
  name                  = "${var.function_name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_function {
    function = var.function_name
  }
}

# Defines a backend service that uses the above Serverless NEG as its backend target.
resource "google_compute_backend_service" "function_backend" {
  name                            = "${var.function_name}-backend"
  protocol                        = "HTTP"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  enable_cdn                      = false

  backend {
    group = google_compute_region_network_endpoint_group.function_neg.id
  }
}

# Routes incoming requests to the backend service based on URL path (default is all paths).
resource "google_compute_url_map" "url_map" {
  name            = "${var.function_name}-url-map"
  default_service = google_compute_backend_service.function_backend.id
}

# Sets up an HTTP proxy that connects the URL map to the external Load Balancer.
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.function_name}-http-proxy"
  url_map = google_compute_url_map.url_map.id
}
# Creates a global IP and port 80 forwarding rule that points to the HTTP proxy, exposing the function to the internet.
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name                  = "${var.function_name}-http-rule"
  target                = google_compute_target_http_proxy.http_proxy.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
}


