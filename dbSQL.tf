resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta
  name          = var.gobal-addr-name
  purpose       = var.global-addr-purpose
  address_type  = var.global-addr-type
  prefix_length = var.global-addr-prefixLen
  network       = google_compute_network.vpc_network.id
  address       = var.global-addr-ip-addr
}

resource "google_service_networking_connection" "svc_ntw_conn" {
  provider                = google-beta
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
  depends_on              = [google_compute_global_address.private_ip_address]
}

resource "google_sql_database_instance" "db-instance" {
  name                = "db-${random_string.instance-name.result}-inst"
  database_version    = var.db-version
  encryption_key_name = google_kms_crypto_key.sql-instance-key.id
  settings {
    tier      = var.sql-inst-tier
    disk_size = var.sql-inst-disk-size
    disk_type = var.sql-inst-disk-type

    ip_configuration {
      ipv4_enabled    = var.db-inst-ipv4
      private_network = google_compute_network.vpc_network.id
    }
    availability_type = var.sql-inst-avail-type
  }
  project             = var.project_id
  deletion_protection = false
  depends_on = [google_compute_network.vpc_network,
  google_service_networking_connection.svc_ntw_conn, google_kms_crypto_key_iam_binding.sql-key-iam]
}

resource "google_sql_database" "database" {
  name       = var.db-name
  instance   = google_sql_database_instance.db-instance.id
  project    = var.project_id
  depends_on = [google_sql_database_instance.db-instance]
}

resource "google_sql_user" "users" {
  name     = var.db-username
  instance = google_sql_database_instance.db-instance.id
  password = random_password.password.result
  depends_on = [google_sql_database_instance.db-instance, google_sql_database.database,
  random_password.password]
  deletion_policy = var.db-user-del-pol
}