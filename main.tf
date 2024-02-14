provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
resource "random_string" "vpc_name" {
  length  = 10
  special = false
  upper   = false
}
resource "google_compute_network" "vpc_network" {
  //name                    = "${random_string.vpc_name.result}-vpc"
  count                           = var.vpc_count
  name                            = "cloud-vpc-${count.index + 1}"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

resource "google_compute_subnetwork" "subnet-1" {
  count         = var.vpc_count
  name          = "${var.subnet-1-name}-${count.index + 1}"
  ip_cidr_range = element(var.ip_cidr_range_subnet_1, count.index)
  region        = var.region
  network       = google_compute_network.vpc_network[count.index].name
}

resource "google_compute_subnetwork" "subnet-2" {
  count         = var.vpc_count
  name          = "${var.subnet-2-name}-${count.index + 1}"
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