output "instance_name" {
  description = "Evidence runner VM name."
  value       = google_compute_instance.evidence_runner.name
}

output "instance_zone" {
  description = "Evidence runner VM zone."
  value       = google_compute_instance.evidence_runner.zone
}

output "service_account_email" {
  description = "Evidence runner runtime service account email."
  value       = google_service_account.evidence_runner.email
}
