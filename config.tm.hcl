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
