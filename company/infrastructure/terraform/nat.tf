# Cloud Router for Outbound Traffic
resource "google_compute_router" "router" {
  name    = "router-${var.environment}"
  region  = var.region
  network = google_compute_network.vpc.id
}

# Cloud NAT Gateway for Private GKE Nodes
resource "google_compute_router_nat" "nat" {
  name                               = "nat-${var.environment}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
