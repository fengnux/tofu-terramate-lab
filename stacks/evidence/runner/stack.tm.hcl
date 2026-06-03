stack {
  name        = "runner"
  description = "Evidence pack 專用執行 VM（DuckDB / Trivy / GCS evidence pipeline）。"
  id          = "evidence-runner"
  tags        = ["evidence", "evidence-runner"]
  after       = ["/stacks/dev/network", "/stacks/evidence/storage"]
}
