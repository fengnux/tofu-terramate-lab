output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE cluster 名稱"
}

output "cluster_location" {
  value       = google_container_cluster.primary.location
  description = "Cluster region（Autopilot 限定 regional）"
}

output "endpoint" {
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
  description = "Private endpoint IP（從 master_ipv4_cidr 分配）"
}

output "ca_certificate" {
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
  description = "Cluster CA 憑證（base64 encoded）"
}

output "workload_identity_pool" {
  value       = google_container_cluster.primary.workload_identity_config[0].workload_pool
  description = "格式 PROJECT_ID.svc.id.goog，供 KSA→GSA binding 用"
}
