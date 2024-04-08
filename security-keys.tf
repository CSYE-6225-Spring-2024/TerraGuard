
data "google_kms_key_ring" "keyring" {
  name     = "keyring-webapp"
  location = var.region
}

data "google_kms_crypto_key" "sql-instance-key" {
  name     = "cloudsql-instance-key"
  key_ring = data.google_kms_key_ring.keyring.id
}

resource "google_kms_crypto_key_iam_binding" "sql-key-iam" {
  provider      = google-beta
  crypto_key_id = data.google_kms_crypto_key.sql-instance-key.id
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

data "google_kms_crypto_key" "storage-bucket-key" {
  name     = "storagebucket-key"
  key_ring = data.google_kms_key_ring.keyring.id
}

resource "google_kms_crypto_key_iam_binding" "storage-bucket-binding" {
  crypto_key_id = data.google_kms_crypto_key.storage-bucket-key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members    = ["serviceAccount:${data.google_storage_project_service_account.gcs_account_bucket.email_address}"]
  depends_on = [data.google_kms_crypto_key.storage-bucket-key]
}

data "google_kms_crypto_key" "vminstance-key" {
  name     = "vm-instance-key"
  key_ring = data.google_kms_key_ring.keyring.id
}

data "google_project" "project" {
}

resource "google_project_iam_binding" "vminstance-binding-key" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = ["serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"]
}

