stack {
  id          = "github-actions-wif"
  name        = "github-actions-wif"
  description = "GitHub Actions OIDC / Workload Identity Federation for OpenTofu CI/CD"
  tags        = ["ci", "wif"]
  after       = ["/stacks/bootstrap"]
}
