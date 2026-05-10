resource "google_storage_bucket" "tofu_state" {
  name     = "research-lab-495809-tofu-state"
  location = "asia-east1"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  soft_delete_policy {
    retention_duration_seconds = 7776000 # 90 天
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 10
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    purpose     = "tofu-state"
    environment = "shared"
  }

  lifecycle {
    prevent_destroy = true
  }
}
