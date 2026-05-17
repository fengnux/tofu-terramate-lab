globals "network" {
  cidr_primary        = "10.10.0.0/20"
  cidr_pods           = "10.20.0.0/14"
  cidr_services       = "10.30.0.0/20"
  pods_range_name     = "${global.env.name_prefix}-pods"
  services_range_name = "${global.env.name_prefix}-services"
  iap_source_range    = "35.235.240.0/20"
}
