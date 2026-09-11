output "gke_cluster_name" {
  value       = google_container_cluster.gke_cluster.name
  description = "GKE Cluster Name"
}

output "gke_cluster_endpoint" {
  value       = google_container_cluster.gke_cluster.endpoint
  description = "GKE Master IP Endpoint"
}

output "cloud_sql_private_ip" {
  value       = google_sql_database_instance.postgres.private_ip_address
  description = "Cloud SQL Private IP Address"
}

output "cloud_sql_instance_name" {
  value       = google_sql_database_instance.postgres.name
  description = "Cloud SQL Instance Name"
}

output "cloud_sql_public_ip" {
  value       = google_sql_database_instance.postgres.public_ip_address
  description = "Cloud SQL Public IP Address"
}
