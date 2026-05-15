resource "google_compute_instance" "dev_vm" {
  name         = "dev-vm"
  machine_type = "e2-micro"
  zone         = "asia-east1-b"
  project      = var.project_id

  tags = ["iap-ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = "dev-vpc"
    subnetwork = "projects/${var.project_id}/regions/asia-east1/subnetworks/dev-subnet-asia-east1"
    # access_config 不加 → 無 public IP
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}
