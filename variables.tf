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