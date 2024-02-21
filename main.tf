provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                            = "cloud-${var.vpc_name}-vpc"
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
  name          = var.subnet-2-name
  ip_cidr_range = var.ip_cidr_range_subnet_2[0]
  region        = var.region
  network       = google_compute_network.vpc_network.id
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
    google_compute_firewall.webapp-firewall1,
    google_compute_firewall.webapp-firewall2
  ]

  tags = var.webapp-inst-tags
}