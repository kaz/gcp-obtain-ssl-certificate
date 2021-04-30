resource "google_storage_bucket" "certificates" {
  name     = "${data.google_project.project.project_id}-certificates"
  location = local.region

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
resource "google_storage_bucket_iam_binding" "certificates_object_admin" {
  bucket = google_storage_bucket.certificates.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.certbot.email}",
  ]
}
resource "google_storage_bucket_iam_binding" "certificates_object_viewer" {
  bucket = google_storage_bucket.certificates.name
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:${google_service_account.instance.email}",
  ]
}
