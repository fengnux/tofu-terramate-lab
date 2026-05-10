output "state_bucket_name" {
  description = "GCS bucket name for OpenTofu remote state"
  value       = google_storage_bucket.tofu_state.name
}

output "state_bucket_url" {
  description = "GCS bucket gs:// URL"
  value       = google_storage_bucket.tofu_state.url
}
