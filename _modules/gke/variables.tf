variable "name_prefix" {
  type        = string
  description = "資源命名前綴（dev / staging / prod）"
}

variable "location" {
  type        = string
  description = "Cluster location；Autopilot 限定 region 字串（如 asia-east1）"
}

variable "network_self_link" {
  type        = string
  description = "VPC self_link（由 stack 端 data source 傳入）"
}

variable "subnetwork_self_link" {
  type        = string
  description = "Subnet self_link（由 stack 端 data source 傳入）"
}

variable "pods_range_name" {
  type        = string
  description = "Subnet 內 GKE pods alias range 名稱"
}

variable "services_range_name" {
  type        = string
  description = "Subnet 內 GKE services alias range 名稱"
}

variable "master_ipv4_cidr" {
  type        = string
  description = "Control plane VPC peering CIDR（必須 /28）"
}

variable "master_authorized_cidrs" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "允許存取 private endpoint 的 CIDR 清單（如 dev-subnet 主要範圍）"
}

variable "release_channel" {
  type        = string
  default     = "REGULAR"
  description = "GKE release channel；REGULAR / RAPID / STABLE"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Provider 7.x 預設 true；lab 端可關閉以便 destroy"
}
