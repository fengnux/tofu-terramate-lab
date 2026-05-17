terraform {
  required_version = ">= 1.10"
  required_providers {
    google = {
      source  = "registry.opentofu.org/hashicorp/google"
      version = ">= 7.0"
    }
  }
}
