generate_hcl "_module_vpc.tf" {
  content {
    module "vpc" {
      source = "../../../_modules/network"

      name_prefix         = global.env.name_prefix
      region              = global.gcp.region
      cidr_primary        = global.network.cidr_primary
      cidr_pods           = global.network.cidr_pods
      cidr_services       = global.network.cidr_services
      pods_range_name     = global.network.pods_range_name
      services_range_name = global.network.services_range_name
      iap_source_range    = global.network.iap_source_range
    }
  }
}
