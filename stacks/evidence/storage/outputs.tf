output "bucket_name" {
  description = "Evidence bucket 名稱"
  value       = google_storage_bucket.evidence.name
}

output "bucket_url" {
  description = "Evidence bucket gs:// URL"
  value       = google_storage_bucket.evidence.url
}
