generate_hcl "_module_gke.tf" {
  content {
    data "google_compute_network" "vpc" {
      name = "${global.env.name_prefix}-vpc"
    }

    data "google_compute_subnetwork" "primary" {
      name   = "${global.env.name_prefix}-subnet-${global.gcp.region}"
      region = global.gcp.region
    }

    module "gke" {
      source = "../../../_modules/gke"

      name_prefix          = global.env.name_prefix
      location             = global.gcp.region
      network_self_link    = data.google_compute_network.vpc.self_link
      subnetwork_self_link = data.google_compute_subnetwork.primary.self_link
      pods_range_name      = global.network.pods_range_name
      services_range_name  = global.network.services_range_name

      master_ipv4_cidr        = global.gke.master_cidr
      master_authorized_cidrs = global.gke.master_authorized_cidrs
      release_channel         = global.gke.release_channel
      deletion_protection     = global.gke.deletion_protection
    }
  }
}
