data "google_client_config" "current" {}

locals {
  github_repo = "fengnux/tofu-terramate-lab"

  pool_id     = "github-actions"
  provider_id = "github"

  service_account_id      = "github-actions-tofu"
  plan_service_account_id  = "github-actions-tofu-plan"
  drift_service_account_id = "github-actions-tofu-drift"

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

  plan_project_roles = [
    "roles/storage.objectViewer",
    "roles/compute.viewer",
    "roles/serviceusage.serviceUsageViewer",
  ]

  drift_project_roles = [
    "roles/storage.objectViewer",
    "roles/compute.viewer",
    "roles/serviceusage.serviceUsageViewer",
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

resource "google_service_account" "github_actions_tofu_plan" {
  account_id   = local.plan_service_account_id
  display_name = "GitHub Actions OpenTofu Plan"
  description  = "Read-only SA for PR plan jobs via Workload Identity Federation"

  depends_on = [
    google_project_service.required["iam.googleapis.com"],
  ]
}

resource "google_service_account_iam_member" "github_actions_wif" {
  service_account_id = google_service_account.github_actions_tofu.name
  role               = "roles/iam.workloadIdentityUser"
  # apply workflow 走 GitHub Environment "production" approval gate（Lab 04a），
  # OIDC sub claim 為 environment 形式而非 ref，binding 需對齊
  member = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/subject/repo:${local.github_repo}:environment:production"
}

resource "google_service_account" "github_actions_tofu_drift" {
  account_id   = local.drift_service_account_id
  display_name = "GitHub Actions OpenTofu Drift"
  description  = "Read-only SA for scheduled drift detection via Workload Identity Federation"

  depends_on = [
    google_project_service.required["iam.googleapis.com"],
  ]
}

resource "google_service_account_iam_member" "github_actions_wif_drift" {
  service_account_id = google_service_account.github_actions_tofu_drift.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/subject/repo:${local.github_repo}:ref:refs/heads/main"
}

resource "google_project_iam_member" "github_actions_tofu_drift" {
  for_each = toset(local.drift_project_roles)

  project = data.google_client_config.current.project
  role    = each.value
  member  = google_service_account.github_actions_tofu_drift.member
}

resource "google_service_account_iam_member" "github_actions_wif_plan" {
  service_account_id = google_service_account.github_actions_tofu_plan.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principal://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/subject/repo:${local.github_repo}:pull_request"
}

resource "google_project_iam_member" "github_actions_tofu_plan" {
  for_each = toset(local.plan_project_roles)

  project = data.google_client_config.current.project
  role    = each.value
  member  = google_service_account.github_actions_tofu_plan.member
}

resource "google_project_iam_member" "github_actions_tofu" {
  for_each = toset(local.ci_project_roles)

  project = data.google_client_config.current.project
  role    = each.value
  member  = google_service_account.github_actions_tofu.member
}
