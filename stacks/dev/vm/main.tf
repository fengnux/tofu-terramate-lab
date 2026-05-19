data "google_client_config" "current" {}

resource "google_service_account" "dev_vm" {
  account_id   = "dev-vm"
  display_name = "dev-vm runtime"
  description  = "dev-vm 執行身份；K8s 實驗系列共用"
}

resource "google_project_iam_member" "dev_vm_container_developer" {
  project = data.google_client_config.current.project
  role    = "roles/container.developer"
  member  = google_service_account.dev_vm.member
}

resource "google_project_iam_member" "dev_vm_container_cluster_viewer" {
  project = data.google_client_config.current.project
  role    = "roles/container.clusterViewer"
  member  = google_service_account.dev_vm.member
}

resource "google_compute_instance" "dev_vm" {
  name         = "dev-vm"
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
    # access_config 不加 → 無 public IP
  }

  service_account {
    email  = google_service_account.dev_vm.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}
