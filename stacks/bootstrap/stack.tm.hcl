stack {
  name        = "bootstrap"
  description = "建立 GCS state bucket 作為其他 stack 的 remote backend。本 stack 使用 local state（雞生蛋問題）。"
  id          = "bootstrap"
  tags        = ["bootstrap", "foundational"]
}

# 此 stack 不繼承 root 自動產生的 backend 設定（若日後加上）。
# 為避免 _terramate_provider.tf 重複產生 default_labels 但又需 local state，
# 此處保留 root 的 generate_hcl，僅靠不寫 backend 來維持 local state。
