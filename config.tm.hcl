globals "gcp" {
  lab_project  = "research-lab-495809"
  region       = "asia-east1"
  state_bucket = "research-lab-495809-tofu-state"
}

globals "tofu" {
  required_version = "~> 1.11.6"
  google_provider  = "~> 7.31.0"
}

globals "labels" {
  managed_by  = "opentofu"
  source_repo = "tofu-terramate-hcl"
}

globals "owner" {
  # 個人 GCP 帳號，用於非 production 資源的 reader / debug binding
  # （per audit ADR-003 §3.1：明寫 reader binding 顯化讀取者意圖，不依賴 project Owner）
  personal_email = "fengnux@gmail.com"
}
