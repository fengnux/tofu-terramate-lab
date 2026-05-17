output "vpc_self_link" {
  value       = module.vpc.vpc_self_link
  description = "dev VPC 的 self_link（供其他資源參照）"
}

output "vpc_name" {
  value       = module.vpc.vpc_name
  description = "dev VPC 名稱"
}

output "subnet_self_link" {
  value       = module.vpc.subnet_self_link
  description = "asia-east1 主要子網路的 self_link"
}

output "subnet_name" {
  value       = module.vpc.subnet_name
  description = "asia-east1 主要子網路名稱"
}

output "pods_range_name" {
  value       = module.vpc.pods_range_name
  description = "GKE alias IP range（pods），未來 GKE lab 使用"
}

output "services_range_name" {
  value       = module.vpc.services_range_name
  description = "GKE alias IP range（services），未來 GKE lab 使用"
}
