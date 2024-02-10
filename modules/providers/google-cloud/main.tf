provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name                    = "test-vpc"
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
}

resource "google_compute_subnetwork" "subnet-1" {
  name          = var.subnet-1-name
  ip_cidr_range = var.ip_cidr_range_subnet_1
  region        = var.region
  network       = google_compute_network.vpc_network.self_link

}

resource "google_compute_subnetwork" "subnet-2" {
  name          = var.subnet-2-name
  ip_cidr_range = var.ip_cidr_range_subnet_2
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_route" "subnet-1-route" {
  name             = "${var.subnet-1-name}-route"
  dest_range       = var.route_dst_ip
  network          = google_compute_network.vpc_network.self_link
  next_hop_gateway = "default-internet-gateway"
}