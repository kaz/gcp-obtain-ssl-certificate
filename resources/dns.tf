locals {
  domain = "isucon.xyz" //TODO
}

resource "google_dns_managed_zone" "zone" {
  name     = "zone"
  dns_name = "${local.domain}."
}

resource "google_dns_record_set" "record" {
  name         = google_dns_managed_zone.zone.dns_name
  managed_zone = google_dns_managed_zone.zone.name

  type    = "A"
  ttl     = 300
  rrdatas = [google_compute_instance.instance.network_interface[0].access_config[0].nat_ip]
}
