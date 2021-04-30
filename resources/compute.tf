data "google_compute_network" "default" {
  name = "default"
}

locals {
  allow_http_tag = "allow-http"
}

resource "google_compute_firewall" "allow_http" {
  name    = local.allow_http_tag
  network = data.google_compute_network.default.name

  target_tags = [local.allow_http_tag]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_service_account" "instance" {
  account_id   = "instance"
  display_name = "instance"
}

resource "google_compute_instance" "instance" {
  name         = "instance"
  machine_type = "e2-micro"
  zone         = "${local.region}-b"

  tags = [local.allow_http_tag]
  network_interface {
    network = data.google_compute_network.default.name
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = "projects/arch-linux-gce/global/images/family/arch"
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  service_account {
    email  = google_service_account.instance.email
    scopes = ["storage-ro"]
  }

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"

    startup-script = file("../startup-script.py")
    certs-bucket   = google_storage_bucket.certificates.name
    certs-name     = local.domain
  }
}
