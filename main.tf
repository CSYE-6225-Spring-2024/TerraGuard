provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                            = "cloud-test-${var.vpc_name}-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet-1" {
  name          = var.subnet-1-name
  ip_cidr_range = var.ip_cidr_range_subnet_1[0]
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet-2" {
  name                     = var.subnet-2-name
  ip_cidr_range            = var.ip_cidr_range_subnet_2[0]
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_route" "webapp-route" {
  name             = "cloud-${var.subnet-1-name}-route"
  dest_range       = var.route_dst_ip
  network          = google_compute_network.vpc_network.id
  next_hop_gateway = var.route_gateway
}

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

resource "google_compute_instance" "webapp-instance" {
  name = var.vm_instance_name
  boot_disk {
    initialize_params {
      image = var.image_name
      type  = var.disk_type
      size  = var.disk_size
    }
  }
  machine_type = var.instance_machine_type
  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet-1.id
    access_config {
      network_tier = var.access_config_network_tier
    }
  }
  allow_stopping_for_update = true
  depends_on = [
    google_compute_network.vpc_network,
    google_compute_firewall.webapp-firewall1,
    google_compute_firewall.webapp-firewall2
  ]

  tags = var.webapp-inst-tags
  metadata = {
    startup-script = <<-EOT
#!/bin/bash
cd /opt/webapp/
sudo tee -a .env <<EOF >/dev/null
DB_NAME=webapp
DB_PWD=testing
DB_USER=webapp
HOST=${google_sql_database_instance.db-instance.private_ip_address}
EOF
EOT
  }
}

# resource "google_compute_global_address" "default" {
#   provider     = google-beta
#   project      = var.project_id
#   name         = "global-psconnect-ip"
#   address_type = "INTERNAL"
#   purpose      = "PRIVATE_SERVICE_CONNECT"
#   network      = google_compute_network.vpc_network.id
#   address      = "10.16.1.0"
# }

# resource "google_compute_global_forwarding_rule" "default" {
#   provider              = google-beta
#   project               = var.project_id
#   name                  = "globalrule"
#   target                = "all-apis"
#   network               = google_compute_network.vpc_network.id
#   ip_address            =  google_compute_global_address.default.id
#   load_balancing_scheme = ""
#   service_directory_registrations {
#     namespace                = "sd-namespace"
#     service_directory_region = var.region
#   }
# }

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpc_network.id
  address       = "10.0.2.0"
}

resource "google_service_networking_connection" "svc-ntw-conn" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  deletion_policy         = "ABANDON"
}

resource "random_password" "password" {
  length           = 10
  special          = false
  upper            = false
  numeric          = false
}

resource "random_string" "instance-name" {
  length = 5
  special = false
  upper = false
  numeric = false
}

resource "google_sql_database_instance" "db-instance" {
  name             = "db-${random_string.instance-name.result}-instance"
  database_version = var.db-version
  settings {
    tier      = var.sql-inst-tier
    disk_size = var.sql-inst-disk-size
    disk_type = var.sql-inst-disk-type

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
    availability_type = var.sql-inst-avail-type
  }
  project             = var.project_id
  deletion_protection = false
  depends_on = [google_compute_network.vpc_network,
  google_service_networking_connection.svc-ntw-conn]
}

resource "google_sql_database" "database" {
  name       = var.db-name
  instance   = google_sql_database_instance.db-instance.id
  project    = var.project_id
  depends_on = [google_sql_database_instance.db-instance]
}

resource "google_sql_user" "users" {
  name       = var.db-username
  instance   = google_sql_database_instance.db-instance.id
  password   = random_password.password.result
  project    = var.project_id
  depends_on = [google_sql_database_instance.db-instance]
}
