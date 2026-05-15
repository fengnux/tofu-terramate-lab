generate_hcl "_terramate_locals.tf" {
  content {
    locals {
      project_id = global.gcp.lab_project
    }
  }
}
