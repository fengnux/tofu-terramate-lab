variable "name_prefix" {
  type        = string
  description = "資源命名前綴，例如 dev / staging / prod"
}

variable "region" {
  type        = string
  description = "subnet 與 Cloud Router 所在 region"
}

variable "cidr_primary" {
  type        = string
  description = "主要 subnet CIDR"
}

variable "cidr_pods" {
  type        = string
  description = "GKE pods secondary range CIDR"
}

variable "cidr_services" {
  type        = string
  description = "GKE services secondary range CIDR"
}

variable "pods_range_name" {
  type        = string
  description = "GKE pods alias range name"
}

variable "services_range_name" {
  type        = string
  description = "GKE services alias range name"
}

variable "iap_source_range" {
  type        = string
  description = "IAP TCP forwarding 來源 CIDR（GCP 固定 35.235.240.0/20）"
  default     = "35.235.240.0/20"
}
