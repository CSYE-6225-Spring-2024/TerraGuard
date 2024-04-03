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

variable "web-port" {
  type        = number
  description = "Web app port"
}

variable "gobal-addr-name" {
  type        = string
  description = "Global Address Name"
}

variable "db-port" {
  type        = number
  description = "Database port for postgres"
}

variable "db-user-del-pol" {
  type        = string
  description = "Database user deletion policy"
}

variable "db-allow-tags" {
  type        = list(string)
  description = "Allow instances to connect to DB"
}

variable "db-allow-fw-name" {
  type        = string
  description = "Firewall name to allow traffic from db instance"
}

variable "db-deny-fw-name" {
  type        = string
  description = "Firewall name to deny traffic from db instance"
}

variable "db-deny-priority" {
  type        = number
  description = "Priority to firewall that denies traffic from db instance"
}

variable "db-allow-fw-ports" {
  type        = list(string)
  description = "Firewall allow DB access ports"
}

variable "db-allow-fw-prot" {
  type        = string
  description = "Firewall allow DB access protocol"
}

variable "db-deny-fw-ports" {
  type        = list(string)
  description = "Firewall deny DB access ports"
}

variable "db-deny-fw-prot" {
  type        = string
  description = "Firewall allow DB deny protocol"
}

variable "db-allow-fw-dir" {
  type        = string
  description = "Allow firewall direction"
}

variable "db-deny-fw-dir" {
  type        = string
  description = "Deny firewall direction"
}

variable "db-inst-ipv4" {
  type        = bool
  description = "Bool value of public IPV4 enabling in SQL Instance"
}

variable "dns_zone_name" {
  type        = string
  description = "DNS Zone Name"
}

variable "dns_name" {
  type        = string
  description = "DNS Name"
}

variable "dns_record_type" {
  type        = string
  description = "DNS Record Type"
}

variable "google_service_accountID" {
  type        = string
  description = "google service account id"
}

variable "google_service_accountID_emailing" {
  type        = string
  description = "google service account for email purposes"
}

variable "service_acc_display_name" {
  type        = string
  description = "Service account display name"
}

variable "iam_bind_role_1" {
  type        = string
  description = "IAM bind role 1"
}

variable "iam_bind_role_2" {
  type        = string
  description = "IAM bind role 2"
}

variable "node_env" {
  type        = string
  description = "NODE Environment Type"
}

variable "email_expiry_time" {
  type        = number
  description = "Email expiration time"
}

variable "cloud_func_fw" {
  type        = string
  description = "Name of cloud function firewall giving access to talk to DB"
}

variable "cf-protocol-fw" {
  type        = string
  description = "cloud function firewall - protocol"
}

variable "cf-port-fw" {
  type        = list(string)
  description = "cloud function firewall - port"
}

variable "cf-priority-fw" {
  type        = number
  description = "cloud function firewall - priority"
}

variable "cf-direction-fw" {
  type        = string
  description = "cloud function firewall - direction"
}

variable "cf-name" {
  type        = string
  description = "cloud function name"
}

variable "cf-runtime" {
  type        = string
  description = "cloud function run time"
}

variable "cf-entrypoint" {
  type        = string
  description = "cloud function entrypoint"
}

variable "cf-max_instance_count" {
  type        = number
  description = "cloud function max instance count"
}

variable "cf-available_memory" {
  type        = string
  description = "cloud function available_memory "
}

variable "cf-timeout_seconds" {
  type        = number
  description = "cloud function timeout_seconds "
}

variable "cf-event_type" {
  type        = string
  description = "cloud function event_type"
}

variable "cf-retry_policy" {
  type        = string
  description = "cloud function retry_policy"
}

variable "pubsub-topicName" {
  type        = string
  description = "pubsub topic name"
}

variable "pubsub-message_retention_duration" {
  type        = string
  description = "pubsub message retention time"
}

variable "pubsub-role" {
  type        = string
  description = "pubsub-role IAM binding"
}

variable "cf-role1" {
  type        = string
  description = "cf-role1 IAM binding"
}

variable "cf-role2" {
  type        = string
  description = "cf-role2 IAM binding"
}

variable "vac-name" {
  type        = string
  description = "VPC access connector name"
}

variable "vac-ip_cidr_range" {
  type        = string
  description = "VPC access connector name"
}

variable "vac-machine_type" {
  type        = string
  description = "VPC access connector name"
}

variable "cf-source_ranges" {
  type        = list(string)
  description = "Cloud function source ranges"
}

variable "cf-mailgun-api" {
  type        = string
  description = "Mailgun private API key"
}

variable "cf-link-domain" {
  type        = string
  description = "Domain name"
}

variable "cf-email-domain" {
  type        = string
  description = "Email domain name"
}

variable "subscription-name" {
  type        = string
  description = "Subscription name"
}

variable "nameOfBucket" {
  type        = string
  description = "Name of the bucket"
}

variable "nameOfStorageBucketFile" {
  type        = string
  description = "Name of the file in bucket"
}

variable "webapp-template-name" {
  type        = string
  description = "Name of the webapp template"
}

variable "webapp-health-check-name" {
  type        = string
  description = "Name of the webapp health check"
}
variable "webapp-health-check-timeout_sec" {
  type        = number
  description = "timeout seconds of the webapp health check"
}

variable "webapp-health-check-check_interval_sec" {
  type        = number
  description = "Check interval seconds of the webapp health check"
}

variable "webapp-health-check-healthy_threshold" {
  type        = number
  description = "healthy threshold seconds of the webapp health check"
}

variable "webapp-health-check-unhealthy_threshold" {
  type        = number
  description = "unhealthy threshold seconds of the webapp health check"
}

variable "webapp-health-check-request_path" {
  type        = string
  description = "Request path for webapp health"
}

variable "mig-name" {
  type        = string
  description = "MIG name"
}

variable "mig-base_instance_name" {
  type        = string
  description = "MIG instance name"
}

variable "mig-distribution_policy_zones" {
  type        = list(string)
  description = "MIG distribution policy zones"
}

variable "mig-named_port" {
  type        = string
  description = "MIG mig port name"
}

variable "autoscaler-name" {
  type        = string
  description = "Autoscaler name"
}

variable "autoscaler-max_replicas" {
  type        = number
  description = "autoscaler-max_replicas"
}

variable "autoscaler-min_replicas" {
  type        = number
  description = "autoscaler-min_replicas"
}

variable "autoscaler-cooldown_period" {
  type        = number
  description = "autoscaler-cooldown_period"
}

variable "autoscaler-cpu-utilization-target" {
  type        = number
  description = "autoscaler cpu util target"
}

variable "mig-initial_delay_sec" {
  type        = number
  description = "MIG initial delay seconds"
}

variable "lb-name" {
  type        = string
  description = "Load balancer name"
}

variable "lb-managed_ssl_certificate_domains" {
  type        = list(string)
  description = "Load balancer ssl certificate domain"
}
variable "lb-backend-timeout_sec" {
  type        = number
  description = "Load balancer backend service timeout sec"
}