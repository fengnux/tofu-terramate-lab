data "google_client_config" "current" {}

locals {
  github_repo = "fengnux/tofu-terramate-lab"

  pool_id     = "github-actions"
  provider_id = "github"

  service_account_id = "github-actions-tofu"

  required_apis = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ]

  ci_project_roles = [
    "roles/storage.objectAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/iap.tunnelResourceAccessor",
    "roles/iam.serviceAccountTokenCreator",
  ]
}

resource "google_project_service" "required" {
  for_each = toset(local.required_apis)

  service            = each.value
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = local.pool_id
  display_name              = "GitHub Actions"
  description               = "OIDC identities from GitHub Actions for tofu-terramate-lab"
  disabled                  = false

  depends_on = [
    google_project_service.required["iam.googleapis.com"],
  ]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = local.provider_id
  display_name                       = "fengnux/tofu-terramate-lab"
  description                        = "GitHub OIDC provider restricted to fengnux/tofu-terramate-lab"
  disabled                           = false

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.ref"              = "assertion.ref"
    "attribute.workflow"         = "assertion.workflow"
  }

  attribute_condition = "assertion.repository == '${local.github_repo}' && (assertion.ref == 'refs/heads/main' || assertion.ref.startsWith('refs/pull/'))"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_actions_tofu" {
  account_id   = local.service_account_id
  display_name = "GitHub Actions OpenTofu"
  description  = "Impersonated by GitHub Actions through Workload Identity Federation"

  depends_on = [
    google_project_service.required["iam.googleapis.com"],
  ]
}

resource "google_service_account_iam_member" "github_actions_wif" {
  service_account_id = google_service_account.github_actions_tofu.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${local.github_repo}"
}

resource "google_project_iam_member" "github_actions_tofu" {
  for_each = toset(local.ci_project_roles)

  project = data.google_client_config.current.project
  role    = each.value
  member  = google_service_account.github_actions_tofu.member
}
