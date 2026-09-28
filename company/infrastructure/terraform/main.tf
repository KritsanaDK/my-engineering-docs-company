# 1. Custom VPC Network
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# 2. Custom Private Subnet for GKE Nodes, Pods, and Services
resource "google_compute_subnetwork" "subnet" {
  name                     = "subnet-${var.environment}"
  ip_cidr_range            = "10.150.0.0/20"
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  # Secondary IP range for GKE Pods
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.200.0.0/16"
  }

  # Secondary IP range for GKE Services
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.201.0.0/20"
  }
}

# 3. Global Private IP Allocation for Cloud SQL VPC Peering
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-alloc-${var.environment}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

# 4. Service Networking Connection (VPC Peering to Google Managed Services)
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
