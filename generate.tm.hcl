generate_hcl "_terramate_versions.tf" {
  content {
    terraform {
      required_version = global.tofu.required_version

      required_providers {
        google = {
          source  = "registry.opentofu.org/hashicorp/google"
          version = global.tofu.google_provider
        }
      }
    }
  }
}

generate_hcl "_terramate_backend.tf" {
  content {
    terraform {
      backend "gcs" {
        bucket = global.gcp.state_bucket
        prefix = tm_trimprefix(terramate.stack.path.absolute, "/stacks/")
      }
    }
  }
}

generate_hcl "_terramate_provider.tf" {
  content {
    provider "google" {
      project = global.gcp.lab_project
      region  = global.gcp.region

      default_labels = {
        managed-by  = global.labels.managed_by
        source-repo = global.labels.source_repo
        stack       = terramate.stack.name
        environment = tm_try(global.env.name, "shared")
      }
    }
  }
}
