output "vpc_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "VPC 的 self_link，供跨 stack 參照（如 VM、GKE）"
}

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "VPC 名稱"
}

output "subnet_self_link" {
  value       = google_compute_subnetwork.primary.self_link
  description = "主要 subnet 的 self_link"
}

output "subnet_name" {
  value       = google_compute_subnetwork.primary.name
  description = "主要 subnet 名稱"
}

output "pods_range_name" {
  value       = google_compute_subnetwork.primary.secondary_ip_range[0].range_name
  description = "GKE pods alias IP range 名稱（secondary range[0]）"
}

output "services_range_name" {
  value       = google_compute_subnetwork.primary.secondary_ip_range[1].range_name
  description = "GKE services alias IP range 名稱（secondary range[1]）"
}
