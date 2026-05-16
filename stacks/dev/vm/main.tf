// Lab 04 CI verification: trigger PR plan
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

  metadata = {
    enable-oslogin = "TRUE"
  }
}
