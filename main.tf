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

data "google_compute_image" "webapp-image" {
  family  = var.image_name
  project = var.project_id
}

resource "google_compute_region_instance_template" "webapp-template" {
  name         = var.webapp-template-name
  tags         = var.webapp-inst-tags
  machine_type = var.instance_machine_type
  disk {
    source_image = data.google_compute_image.webapp-image.self_link
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size

    disk_encryption_key {
      kms_key_self_link = data.google_kms_crypto_key.vminstance-key.id
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet-1.id
    access_config {
      network_tier = var.access_config_network_tier
    }
  }

  service_account {
    email  = google_service_account.google_service_acc.email
    scopes = ["logging-write", "monitoring-write", "pubsub", "cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }

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

  depends_on = [
    google_compute_network.vpc_network,
    google_compute_subnetwork.subnet-1,
    google_sql_database_instance.db-instance,
    google_service_account.google_service_acc
  ]
}

resource "google_compute_health_check" "webapp-health-check" {
  name                = var.webapp-health-check-name
  timeout_sec         = var.webapp-health-check-timeout_sec
  check_interval_sec  = var.webapp-health-check-check_interval_sec
  healthy_threshold   = var.webapp-health-check-healthy_threshold
  unhealthy_threshold = var.webapp-health-check-unhealthy_threshold

  http_health_check {
    port         = var.web-port
    request_path = var.webapp-health-check-request_path
  }
}

resource "google_compute_region_instance_group_manager" "webapp-mig" {
  provider                  = google-beta
  name                      = var.mig-name
  base_instance_name        = var.mig-base_instance_name
  region                    = var.region
  distribution_policy_zones = var.mig-distribution_policy_zones

  version {
    instance_template = google_compute_region_instance_template.webapp-template.self_link
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp-health-check.id
    initial_delay_sec = var.mig-initial_delay_sec
  }

  all_instances_config {
    metadata = {
      metadata_key = "startup-script"
    }
  }

  named_port {
    name = var.mig-named_port
    port = var.web-port
  }

  depends_on = [google_compute_region_instance_template.webapp-template, google_compute_health_check.webapp-health-check, google_compute_network.vpc_network,
    google_compute_subnetwork.subnet-1,
    google_sql_database_instance.db-instance,
  google_service_account.google_service_acc]
}

resource "google_compute_region_autoscaler" "webapp-autoscaler" {
  name   = var.autoscaler-name
  region = var.region
  target = google_compute_region_instance_group_manager.webapp-mig.id

  autoscaling_policy {
    max_replicas    = var.autoscaler-max_replicas
    min_replicas    = var.autoscaler-min_replicas
    cooldown_period = var.autoscaler-cooldown_period

    cpu_utilization {
      target = var.autoscaler-cpu-utilization-target
    }
  }
  depends_on = [google_compute_region_instance_group_manager.webapp-mig]
}

resource "google_dns_record_set" "DNS_ARecord" {
  name         = var.dns_name
  managed_zone = var.dns_zone_name
  type         = var.dns_record_type
  rrdatas      = [module.gce-lb-http.external_ip]
  depends_on   = [module.gce-lb-http]
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



