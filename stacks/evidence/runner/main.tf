data "google_client_config" "current" {}

locals {
  evidence_bucket_name = "${data.google_client_config.current.project}-evidence"
}

resource "google_service_account" "evidence_runner" {
  account_id   = "evidence-runner"
  display_name = "evidence-runner runtime"
  description  = "Evidence pack runner VM identity for DuckDB / Trivy / GCS evidence pipeline."
}

resource "google_storage_bucket_iam_member" "evidence_runner_reader" {
  bucket = local.evidence_bucket_name
  role   = "roles/storage.objectViewer"
  member = google_service_account.evidence_runner.member
}

resource "google_storage_bucket_iam_member" "evidence_runner_writer" {
  bucket = local.evidence_bucket_name
  role   = "roles/storage.objectCreator"
  member = google_service_account.evidence_runner.member
}

resource "google_compute_instance" "evidence_runner" {
  name         = "evidence-runner"
  machine_type = "e2-micro"
  zone         = "asia-east1-b"

  tags = ["iap-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = "dev-subnet-asia-east1"
    # No access_config: private IP only, SSH goes through IAP.
  }

  service_account {
    email  = google_service_account.evidence_runner.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}
