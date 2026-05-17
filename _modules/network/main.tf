locals {
  vpc_name    = "${var.name_prefix}-vpc"
  subnet_name = "${var.name_prefix}-subnet-${var.region}"
}

resource "google_compute_network" "vpc" {
  name                    = local.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  description             = "${var.name_prefix} shared VPC（lab 環境）"
}

resource "google_compute_subnetwork" "primary" {
  name          = local.subnet_name
  network       = google_compute_network.vpc.id
  region        = var.region
  ip_cidr_range = var.cidr_primary

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = var.pods_range_name
    ip_cidr_range = var.cidr_pods
  }

  secondary_ip_range {
    range_name    = var.services_range_name
    ip_cidr_range = var.cidr_services
  }
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = [var.iap_source_range]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  description = "允許 IAP TCP forwarding 從 ${var.iap_source_range} 對 tag=iap-ssh 的 VM 做 SSH"
}

resource "google_compute_router" "nat" {
  name    = "${var.name_prefix}-nat-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name_prefix}-nat"
  router                             = google_compute_router.nat.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
