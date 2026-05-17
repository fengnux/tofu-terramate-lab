// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

module "vpc" {
  cidr_pods           = "10.20.0.0/14"
  cidr_primary        = "10.10.0.0/20"
  cidr_services       = "10.30.0.0/20"
  iap_source_range    = "35.235.240.0/20"
  name_prefix         = "dev"
  pods_range_name     = "dev-pods"
  region              = "asia-east1"
  services_range_name = "dev-services"
  source              = "../../../_modules/network"
}
