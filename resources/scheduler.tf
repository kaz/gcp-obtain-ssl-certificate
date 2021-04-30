resource "google_service_account" "trigger" {
  account_id   = "trigger"
  display_name = "trigger"
}
resource "google_service_account" "certbot" {
  account_id   = "certbot"
  display_name = "certbot"
}
resource "google_service_account_iam_binding" "certbot_service_account_user" {
  service_account_id = google_service_account.certbot.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.trigger.email}",
  ]
}

resource "google_cloud_scheduler_job" "renew_certificate" {
  name     = "renew-certificate"
  schedule = "0 0 1 */2 *"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/${data.google_project.project.id}/builds"

    headers = {
      "Content-Type" = "application/json"
    }
    body = base64encode(
      jsonencode(
        yamldecode(
          format(
            replace(
              file("../cloudbuild.yaml"),
              "{{domain}}",
              local.domain,
            ),
            google_service_account.certbot.id,
            google_storage_bucket.certificates.url,
          )
        )
      )
    )

    oauth_token {
      service_account_email = google_service_account.trigger.email
    }
  }
}
