output "service_account_email" {
  description = "Service account email impersonated by GitHub Actions via WIF"
  value       = google_service_account.github_actions_tofu.email
}

output "workload_identity_provider_name" {
  description = "Full WIF provider resource name; use as workload_identity_provider in google-github-actions/auth"
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "workload_identity_pool_name" {
  description = "Full WIF pool resource name"
  value       = google_iam_workload_identity_pool.github_actions.name
}

output "github_repository" {
  description = "GitHub repository allowed to impersonate the CI service account"
  value       = local.github_repo
}
