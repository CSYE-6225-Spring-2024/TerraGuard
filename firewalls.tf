resource "google_compute_firewall" "webapp-firewall1" {
  name    = var.firewall_name1
  network = google_compute_network.vpc_network.id
  allow {
    protocol = var.allowed_protocol_firewall1
    ports    = var.application_ports_firewall1
  }

  source_ranges = var.source_ranges_firewall1
  target_tags   = var.fw1-target-tags
}

resource "google_compute_firewall" "webapp-firewall2" {
  name    = var.firewall_name2
  network = google_compute_network.vpc_network.id
  allow {
    protocol = var.allowed_protocol_firewall2
    ports    = var.application_ports_firewall2
  }

  source_ranges = var.source_ranges_firewall2
  target_tags   = var.fw2-target-tags
}

resource "google_compute_firewall" "db-sql-fw" {
  name    = var.db-allow-fw-name
  network = google_compute_network.vpc_network.id
  allow {
    protocol = var.db-allow-fw-prot
    ports    = var.db-allow-fw-ports
  }
  direction          = var.db-allow-fw-dir
  destination_ranges = [google_sql_database_instance.db-instance.private_ip_address]
  target_tags        = var.db-allow-tags
}

resource "google_compute_firewall" "deny-db-sql-fw" {
  name    = var.db-deny-fw-name
  network = google_compute_network.vpc_network.id
  deny {
    protocol = var.db-deny-fw-prot
    ports    = var.db-deny-fw-ports
  }
  priority           = var.db-deny-priority
  direction          = var.db-deny-fw-dir
  destination_ranges = [google_sql_database_instance.db-instance.private_ip_address]
}

resource "google_compute_firewall" "cf-firewall" {
  name    = "cloudf-fw"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  priority           = 900
  direction          = "EGRESS"
  destination_ranges = [google_sql_database_instance.db-instance.private_ip_address]
  source_ranges      = ["10.11.2.0/28"]
}