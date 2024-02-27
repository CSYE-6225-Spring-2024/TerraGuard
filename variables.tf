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

variable "disk_type" {
  type        = string
  description = "Disk type"
}

variable "disk_size" {
  type        = number
  description = "Disk size"
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

variable "webapp-inst-tags" {
  type        = list(string)
  description = "Tags for webapp instance"
}

variable "fw1-target-tags" {
  type        = list(string)
  description = "Tags for firewall1"
}

variable "fw2-target-tags" {
  type        = list(string)
  description = "Tags for firewall2"
}

variable "db-username" {
  type        = string
  description = "Database username"
}

variable "db-name" {
  type        = string
  description = "Database name"
}

variable "db-version" {
  type        = string
  description = "Database version"
}

variable "sql-inst-avail-type" {
  type        = string
  description = "SQL instance - availablility type"
}

variable "sql-inst-disk-type" {
  type        = string
  description = "SQL instance - disk type"
}

variable "sql-inst-disk-size" {
  type        = number
  description = "SQL instance - disk size"
}

variable "sql-inst-tier" {
  type        = string
  description = "SQL instance - disk type"
}

variable "del-pol-svc-ntw" {
  type        = string
  description = "Deletion policy of Service Network Connection"
}

variable "global-addr-purpose" {
  type        = string
  description = "Purpose for global address"
}

variable "global-addr-type" {
  type        = string
  description = "Global address - address type"
}

variable "global-addr-prefixLen" {
  type        = number
  description = "Global address prefix length"
}

variable "global-addr-ip-addr" {
  type        = string
  description = "Global address - IP Address"
}