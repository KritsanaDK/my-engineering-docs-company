# Cloud SQL PostgreSQL Instance (Approved Option 1 Spec)
resource "google_sql_database_instance" "postgres" {
  name             = "insurverse-${var.environment}-db"
  database_version = "POSTGRES_17"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    # Approved Option 1 Spec: 2 vCPU, 7.68 GB RAM
    tier = "db-custom-2-7680"

    availability_type = "ZONAL" # Single Zone (No HA for cost savings)
    disk_type         = "PD_SSD"
    disk_size         = 100
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc.id

      authorized_networks {
        name  = "developer-local-mac"
        value = "183.89.5.65/32"
      }
    }

    backup_configuration {
      enabled            = true
      start_time         = "03:00"
      location           = var.region
      point_in_time_recovery_enabled = false
      transaction_log_retention_days = 7
    }

    insights_config {
      query_insights_enabled = true
    }
  }

  deletion_protection = false
}

# Initial Database
resource "google_sql_database" "database" {
  name     = "insurverse"
  instance = google_sql_database_instance.postgres.name
}

# Master Database User
resource "google_sql_user" "users" {
  name     = "pgpool"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}
