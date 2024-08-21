resource "google_compute_address" "default" {
  name         = "psc-compute-address-${var.instance_name}"
  region       = "us-central1"
  address_type = "INTERNAL"
  subnetwork   = "default"     # Replace value with the name of the subnet here.
  address      = "10.128.0.43" # Replace value with the IP address to reserve.
depends_on = [ data.google_sql_database_instance.default ]
}

data "google_sql_database_instance" "default" {
  name = var.instance_name
}

resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-forwarding-rule-${var.instance_name}"
  region                = "us-central1"
  network               = "default"
  ip_address            = google_compute_address.default.self_link
  load_balancing_scheme = ""
  target                = data.google_sql_database_instance.default.psc_service_attachment_link
depends_on = [ google_compute_address.default ]
}
