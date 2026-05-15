output "enabled_apis" {
  value       = [for s in google_project_service.this : s.service]
  description = "此 stack 啟用的 GCP API 清單"
}
