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
    google_sql_database_instance.db-instance,
    google_service_account.google_service_acc
  ]

  service_account {
    email  = google_service_account.google_service_acc.email
    scopes = ["logging-write", "monitoring-write", "pubsub"]
  }

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
NODE_ENV=${var.node_env}
EMAIL_EXPIRY=${var.email_expiry_time}
EOF
sudo chown csye6225:csye6225 .env
EOT
  }
}

resource "google_dns_record_set" "DNS_ARecord" {
  name         = var.dns_name
  managed_zone = var.dns_zone_name
  type         = var.dns_record_type
  rrdatas      = [google_compute_instance.webapp-instance.network_interface[0].access_config[0].nat_ip]
  depends_on   = [google_compute_instance.webapp-instance]
}

resource "google_service_account" "google_service_acc" {
  account_id   = var.google_service_accountID
  display_name = var.service_acc_display_name
}

resource "google_project_iam_binding" "project_binding_r1" {
  project    = var.project_id
  role       = var.iam_bind_role_1
  members    = [google_service_account.google_service_acc.member]
  depends_on = [google_service_account.google_service_acc]
}

resource "google_project_iam_binding" "project_binding_r2" {
  project    = var.project_id
  role       = var.iam_bind_role_2
  members    = [google_service_account.google_service_acc.member]
  depends_on = [google_service_account.google_service_acc]
}



