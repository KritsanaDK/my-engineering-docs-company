# 1. Private GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name                     = "gke-${var.environment}"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name

  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  release_channel {
    channel = "REGULAR"
  }

  deletion_protection = false
}

# 2. Approved Option 1: Spot VM Node Pool (e2-standard-4)
resource "google_container_node_pool" "spot_nodes" {
  name       = "node-pool-spot-${var.environment}"
  location   = var.zone
  cluster    = google_container_cluster.gke_cluster.name
  node_count = 2

  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    # Approved Cost-Optimization: Spot Instances (60-70% savings)
    spot         = true
    machine_type = "e2-standard-4" # 4 vCPU, 16 GB RAM per node
    disk_size_gb = 50
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      environment = var.environment
      node_type   = "spot"
    }

    tags = ["gke-node", var.environment]
  }
}
