terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "random_password" "password" {
  length  = 10
  special = false
  upper   = false
  numeric = false
}

resource "random_string" "instance-name" {
  length  = 4
  special = false
  upper   = false
  numeric = false
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
  deny {
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
    google_compute_subnetwork.subnet-1,
    google_sql_database_instance.db-instance
  ]

  tags = var.webapp-inst-tags
  metadata = {
    startup-script = <<-EOT
#!/bin/bash
cd /opt/webapp/
if [ -e .env ]; then
  sudo rm .env
fi
sudo tee -a .env <<EOF >/dev/null
DB_NAME=${var.db-name}
DB_PWD=${random_password.password.result}
DB_USER=${var.db-username}
DB_HOST=${google_sql_database_instance.db-instance.private_ip_address}
WEB_PORT=${var.web-port}
DB_PORT=${var.db-port}
EOF
sudo chown csye6225:csye6225 .env
EOT
  }
}

resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta 
  name          = var.gobal-addr-name
  purpose       = var.global-addr-purpose
  address_type  = var.global-addr-type
  prefix_length = var.global-addr-prefixLen
  network       = google_compute_network.vpc_network.id
  address       = var.global-addr-ip-addr
}

resource "google_service_networking_connection" "svc_ntw_conn" {
  provider                = google-beta
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  depends_on              = [google_compute_global_address.private_ip_address]
}

resource "google_sql_database_instance" "db-instance" {
  name             = "db-${random_string.instance-name.result}-inst"
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
  google_service_networking_connection.svc_ntw_conn]
}

resource "google_sql_database" "database" {
  name       = var.db-name
  instance   = google_sql_database_instance.db-instance.id
  project    = var.project_id
  depends_on = [google_sql_database_instance.db-instance]
}

resource "google_sql_user" "users" {
  name     = var.db-username
  instance = google_sql_database_instance.db-instance.id
  password = random_password.password.result
  depends_on = [google_sql_database_instance.db-instance, google_sql_database.database,
  random_password.password]
  deletion_policy = var.db-user-del-pol
}
