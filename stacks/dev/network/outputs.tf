output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.primary.self_link
}

output "subnet_name" {
  value = google_compute_subnetwork.primary.name
}

output "pods_range_name" {
  description = "GKE alias IP range (pods)，未來 GKE lab 會用"
  value       = google_compute_subnetwork.primary.secondary_ip_range[0].range_name
}

output "services_range_name" {
  description = "GKE alias IP range (services)，未來 GKE lab 會用"
  value       = google_compute_subnetwork.primary.secondary_ip_range[1].range_name
}
