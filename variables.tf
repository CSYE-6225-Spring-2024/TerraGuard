variable "project_id" {
  type        = string
  description = "Project ID in GCP"
}

variable "region" {
  type        = string
  description = "Region Name"
}

variable "zone" {
  type        = string
  description = "Zone Name"
}

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "routing_mode" {
  type        = string
  description = "Routing mode for VPC"
}

variable "vpc_count" {
  type        = number
  description = "Count of VPCs to create"
}

variable "subnet-1-name" {
  type        = string
  description = "Subnet 1 name"
}

variable "subnet-2-name" {
  type        = string
  description = "Subnet 2 name"
}

variable "ip_cidr_range_subnet_1" {
  type        = list(string)
  description = "IP CIDR Range Subnet 1"
}

variable "ip_cidr_range_subnet_2" {
  type        = list(string)
  description = "IP CIDR Range Subnet 2"
}

variable "route_dst_ip" {
  type        = string
  description = "Subnet 1 route destination range"
}

variable "route_gateway" {
  type        = string
  description = "Next hop gateway for the route"
}

variable "firewall_name1" {
  type        = string
  description = "Name of the firewall"
}

variable "firewall_name2" {
  type        = string
  description = "Name of the firewall"
}

variable "vm_instance_name" {
  type        = string
  description = "Name of VM Instance of application"
}

variable "access_config_network_tier" {
  type        = string
  description = "Access config of network tier"
}

variable "instance_machine_type" {
  type        = string
  description = "Machine type of webapp-instance"
}

variable "image_name" {
  type        = string
  description = "Image name"
}

variable "image_type" {
  type        = string
  description = "Image type"
}

variable "image_size" {
  type        = number
  description = "Image size"
}

variable "source_ranges_firewall1" {
  type        = list(string)
  description = "Source range of firewall 1"
}

variable "source_ranges_firewall2" {
  type        = list(string)
  description = "Source range of firewall 2"
}


variable "application_ports_firewall1" {
  type        = list(string)
  description = "list of ports for firewall 1"
}

variable "application_ports_firewall2" {
  type        = list(string)
  description = "list of ports for firewall 2"
}


variable "allowed_protocol_firewall1" {
  type        = string
  description = "Allowed protocol for firewall 1"
}

variable "allowed_protocol_firewall2" {
  type        = string
  description = "Allowed protocol for firewall 2"
}