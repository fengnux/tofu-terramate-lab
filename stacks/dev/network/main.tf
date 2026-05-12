locals {
  vpc_name    = "dev-vpc"
  subnet_name = "dev-subnet-asia-east1"

  pods_range_name     = "dev-pods"
  services_range_name = "dev-services"

  cidr_primary  = "10.10.0.0/20"
  cidr_pods     = "10.20.0.0/14"
  cidr_services = "10.30.0.0/20"

  iap_source_range = "35.235.240.0/20"
}

resource "google_compute_network" "vpc" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  description             = "dev shared VPC（lab 環境）"
}

resource "google_compute_subnetwork" "primary" {
  name          = local.subnet_name
  network       = google_compute_network.vpc.id
  region        = "asia-east1"
  ip_cidr_range = local.cidr_primary

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = local.pods_range_name
    ip_cidr_range = local.cidr_pods
  }

  secondary_ip_range {
    range_name    = local.services_range_name
    ip_cidr_range = local.cidr_services
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = [local.iap_source_range]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  description = "允許 IAP TCP forwarding 從 35.235.240.0/20 對 tag=iap-ssh 的 VM 做 SSH"
}

resource "google_compute_router" "nat" {
  name    = "dev-nat-router"
  region  = "asia-east1"
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "dev-nat"
  router                             = google_compute_router.nat.name
  region                             = "asia-east1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
