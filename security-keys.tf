resource "random_string" "keyRing-name" {
  length  = 4
  special = false
  upper   = false
  numeric = false
}

resource "random_string" "key-name" {
  length  = 4
  special = false
  upper   = false
  numeric = false
}
resource "google_kms_key_ring" "keyring" {
  name     = "kr-${random_string.keyRing-name.result}-webapp"
  location = var.region
}

resource "google_kms_crypto_key" "sql-instance-key" {
  name                       = "cloudsql-${random_string.key-name.result}-key"
  key_ring                   = google_kms_key_ring.keyring.id
  rotation_period            = "2592000s"
  destroy_scheduled_duration = "86400s"
}

resource "google_kms_crypto_key_iam_binding" "sql-key-iam" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.sql-instance-key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}"
  ]
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  provider = google-beta
  service  = "sqladmin.googleapis.com"
}

data "google_storage_project_service_account" "gcs_account_bucket" {
}

resource "google_kms_crypto_key" "storage-bucket-key" {
  name                       = "stgebckt-${random_string.key-name.result}-key"
  key_ring                   = google_kms_key_ring.keyring.id
  rotation_period            = "2592000s"
  destroy_scheduled_duration = "86400s"
}

resource "google_kms_crypto_key_iam_binding" "storage-bucket-binding" {
  crypto_key_id = google_kms_crypto_key.storage-bucket-key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members    = ["serviceAccount:${data.google_storage_project_service_account.gcs_account_bucket.email_address}"]
  depends_on = [google_kms_crypto_key.storage-bucket-key]
}

resource "google_kms_crypto_key" "vminstance-key" {
  name                       = "vm-${random_string.key-name.result}-key"
  key_ring                   = google_kms_key_ring.keyring.id
  rotation_period            = "2592000s"
  destroy_scheduled_duration = "86400s"
}

data "google_project" "project" {
}

resource "google_project_iam_binding" "vminstance-binding-key" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = ["serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"]
}

