resource "google_storage_bucket" "evidence" {
  name     = "${data.google_client_config.current.project}-evidence"
  location = data.google_client_config.current.region

  # 安全基線（對齊 state bucket，per research/iac/docs/state-backend.md）
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  # Lifecycle: 各資料源獨立保留期，per audit ADR-003 §3
  # 注意：matches_prefix 接 string（前綴），不是 glob；"sarif/" 即可，無需 "sarif/*"
  lifecycle_rule {
    condition {
      age            = 395 # 13 個月，供年度趨勢
      matches_prefix = ["sarif/"]
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age            = 1095 # 3 年
      matches_prefix = ["asset-inventory/"]
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age            = 400 # 對齊 GCP 預設 Admin Activity log retention
      matches_prefix = ["audit-logs/"]
    }
    action {
      type = "Delete"
    }
  }

  # billing/ 與 reports/ 暫不設 lifecycle（accumulate）
}

# 個人 reader binding：顯化讀取者意圖，不依賴 project Owner 隱含權限
# （per audit ADR-003 §3.1）
resource "google_storage_bucket_iam_member" "personal_reader" {
  bucket = google_storage_bucket.evidence.name
  role   = "roles/storage.objectViewer"
  member = "user:${local.personal_email}"
}

data "google_client_config" "current" {}
