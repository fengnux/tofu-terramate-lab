globals "gcp" {
  lab_project  = "research-lab-495809"
  region       = "asia-east1"
  state_bucket = "research-lab-495809-tofu-state"
}

globals "tofu" {
  required_version = ">= 1.11.0"
  google_provider  = "~> 6.0"
}

globals "labels" {
  managed_by = "opentofu"
  source_repo = "fengnux/tofu-terramate-hcl"
}
