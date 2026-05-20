// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

data "google_compute_network" "vpc" {
  name = "dev-vpc"
}
data "google_compute_subnetwork" "primary" {
  name   = "dev-subnet-asia-east1"
  region = "asia-east1"
}
module "gke" {
  deletion_protection = false
  location            = "asia-east1"
  master_authorized_cidrs = [
    {
      cidr_block   = "10.10.0.0/20"
      display_name = "dev-subnet-primary"
    },
  ]
  master_ipv4_cidr     = "172.16.0.0/28"
  name_prefix          = "dev"
  network_self_link    = data.google_compute_network.vpc.self_link
  pods_range_name      = "dev-pods"
  release_channel      = "REGULAR"
  services_range_name  = "dev-services"
  source               = "../../../_modules/gke"
  subnetwork_self_link = data.google_compute_subnetwork.primary.self_link
}
