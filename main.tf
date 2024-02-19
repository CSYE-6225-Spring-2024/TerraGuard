provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  count                           = var.vpc_count
  name                            = "${var.vpc_name}-${count.index + 1}-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet-1" {
  count         = var.vpc_count
  name          = var.subnet-1-name
  ip_cidr_range = element(var.ip_cidr_range_subnet_1, count.index)
  region        = var.region
  network       = google_compute_network.vpc_network[count.index].name
}

resource "google_compute_subnetwork" "subnet-2" {
  count         = var.vpc_count
  name          = var.subnet-2-name
  ip_cidr_range = element(var.ip_cidr_range_subnet_2, count.index)
  region        = var.region
  network       = google_compute_network.vpc_network[count.index].name
}

resource "google_compute_route" "webapp-route" {
  count            = var.vpc_count
  name             = "${var.subnet-1-name}-route-${count.index + 1}"
  dest_range       = var.route_dst_ip
  network          = google_compute_network.vpc_network[count.index].name
  next_hop_gateway = var.route_gateway
}

resource "google_compute_firewall" "webapp-firewall1" {
  count   = var.vpc_count
  name    = var.firewall_name1
  network = google_compute_network.vpc_network[count.index].id

  allow {
    protocol = var.allowed_protocol_firewall1
    ports    = var.application_ports_firewall1
  }

  source_ranges = var.source_ranges_firewall1
}

resource "google_compute_firewall" "webapp-firewall2" {
  count   = var.vpc_count
  name    = var.firewall_name2
  network = google_compute_network.vpc_network[count.index].id

  deny {
    protocol = var.allowed_protocol_firewall2
    ports    = var.application_ports_firewall2
  }

  source_ranges = var.source_ranges_firewall2
}

resource "google_compute_instance" "webapp-instance" {
  count = var.vpc_count
  name  = var.vm_instance_name
  boot_disk {
    initialize_params {
      image = var.image_name
      type  = var.image_type
      size  = var.image_size
    }
  }
  machine_type = var.instance_machine_type
  network_interface {
    network    = google_compute_network.vpc_network[count.index].id
    subnetwork = google_compute_subnetwork.subnet-1[count.index].id
    access_config {
      network_tier = var.access_config_network_tier
    }
  }

  depends_on = [google_compute_network.vpc_network]
}