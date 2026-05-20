output "cluster_name" {
  value       = module.gke.cluster_name
  description = "GKE cluster 名稱"
}

output "cluster_location" {
  value       = module.gke.cluster_location
  description = "Cluster region"
}

output "workload_identity_pool" {
  value       = module.gke.workload_identity_pool
  description = "Workload Identity pool（PROJECT_ID.svc.id.goog）"
}
