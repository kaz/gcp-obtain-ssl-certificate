resource "google_secret_manager_secret" "zerossl_email" {
  secret_id = "zerossl-email"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret" "zerossl_apikey" {
  secret_id = "zerossl-apikey"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_binding" "zerossl_email_secret_accessor" {
  secret_id = google_secret_manager_secret.zerossl_email.id
  role      = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.certbot.email}",
  ]
}
resource "google_secret_manager_secret_iam_binding" "zerossl_apikey_secret_accessor" {
  secret_id = google_secret_manager_secret.zerossl_apikey.id
  role      = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.certbot.email}",
  ]
}
