output "instance_name" {
  value       = google_compute_instance.dev_vm.name
  description = "Compute Engine 執行個體名稱"
}

output "instance_zone" {
  value       = google_compute_instance.dev_vm.zone
  description = "執行個體所在的 GCP zone"
}
