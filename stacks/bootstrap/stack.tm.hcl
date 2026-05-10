stack {
  name        = "bootstrap"
  description = "建立 GCS state bucket 作為其他 stack 的 remote backend。雞生蛋：先以 local state apply，再 migrate 至同一 bucket（Lab 03a）。"
  id          = "bootstrap"
  tags        = ["bootstrap", "foundational"]
}
