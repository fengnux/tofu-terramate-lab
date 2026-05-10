terramate {
  required_version = "~> 0.17.0"

  config {
    git {
      default_branch = "main"
    }

    # 預設啟用 root-relative 路徑語意，避免 stack 路徑混淆
    experiments = []
  }
}
