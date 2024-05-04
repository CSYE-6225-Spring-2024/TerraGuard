
resource "google_storage_bucket" "nameOfBucket" {
  name                        = var.nameOfBucket
  location                    = var.region
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = google_kms_crypto_key.storage-bucket-key.id
  }
  depends_on = [google_kms_crypto_key_iam_binding.storage-bucket-binding]
}

resource "google_storage_bucket_object" "storageBucketObj" {
  bucket = google_storage_bucket.nameOfBucket.name
  name   = var.nameOfStorageBucketFile
  source = var.source_bucket_file
}

resource "google_cloudfunctions2_function" "cloudFunction" {
  name     = var.cf-name
  location = var.region
  build_config {
    runtime     = var.cf-runtime
    entry_point = var.cf-entrypoint

    source {
      storage_source {
        bucket = google_storage_bucket.nameOfBucket.name
        object = google_storage_bucket_object.storageBucketObj.name
      }
    }
  }

  service_config {
    max_instance_count    = var.cf-max_instance_count
    available_memory      = var.cf-available_memory
    timeout_seconds       = var.cf-timeout_seconds
    service_account_email = google_service_account.google_service_acc_emailing.email
    vpc_connector         = google_vpc_access_connector.connector.id
    environment_variables = {
      DB_NAME      = var.db-name
      DB_PWD       = random_password.password.result
      DB_USER      = var.db-username
      DB_HOST      = google_sql_database_instance.db-instance.private_ip_address
      WEB_PORT     = var.web-port
      DB_PORT      = var.db-port
      MAILGUN_API  = var.cf-mailgun-api
      DOMAIN       = var.cf-link-domain
      EMAIL_DOMAIN = var.cf-email-domain
    }
  }
}

resource "google_pubsub_topic" "webapp_pub_sub" {
  name                       = var.pubsub-topicName
  message_retention_duration = var.pubsub-message_retention_duration
}

resource "google_pubsub_subscription" "webapp_sub" {
  name                       = var.subscription-name
  topic                      = google_pubsub_topic.webapp_pub_sub.name
  message_retention_duration = var.pubsub-message_retention_duration
  push_config {
    push_endpoint = google_cloudfunctions2_function.cloudFunction.service_config[0].uri
    oidc_token {
      service_account_email = google_service_account.google_service_acc_emailing.email
    }
  }
  depends_on = [google_cloudfunctions2_function.cloudFunction]
}
resource "google_service_account" "google_service_acc_emailing" {
  account_id = var.google_service_accountID_emailing
}

resource "google_project_iam_binding" "role-pubsub-publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  members = [google_service_account.google_service_acc.member]
}


resource "google_service_account_iam_binding" "role-token-creater" {
  service_account_id = google_service_account.google_service_acc_emailing.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members = [
    google_service_account.google_service_acc_emailing.member
  ]
  depends_on = [google_service_account.google_service_acc_emailing]
}

resource "google_project_iam_binding" "role-cf-invoker" {
  project    = var.project_id
  role       = "roles/run.invoker"
  members    = [google_service_account.google_service_acc_emailing.member]
  depends_on = [google_service_account.google_service_acc_emailing]
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vac-name
  ip_cidr_range = var.vac-ip_cidr_range
  network       = google_compute_network.vpc_network.id
  machine_type  = var.vac-machine_type
}