locals {
  enabled_apis = [
    "compute.googleapis.com",
    "iap.googleapis.com",
  ]
}

resource "google_project_service" "this" {
  for_each = toset(local.enabled_apis)

  service            = each.value
  disable_on_destroy = false
}
