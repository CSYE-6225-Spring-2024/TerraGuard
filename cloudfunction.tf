resource "google_storage_bucket" "bucket-webapp" {
  name                        = "cf-bucket-csye6225"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object-webapp" {
  name   = "serverless.zip"
  bucket = google_storage_bucket.bucket-webapp.name
  source = "serverless.zip"
}

resource "google_cloudfunctions2_function" "cloudFunction" {
  name     = var.cf-name
  location = var.region
  build_config {
    runtime     = var.cf-runtime
    entry_point = var.cf-entrypoint

    source {
      storage_source {
        bucket = google_storage_bucket.bucket-webapp.name
        object = google_storage_bucket_object.object-webapp.name
      }
    }
  }

  service_config {
    max_instance_count    = var.cf-max_instance_count
    available_memory      = var.cf-available_memory
    timeout_seconds       = var.cf-timeout_seconds
    service_account_email = google_service_account.google_service_acc.email
    vpc_connector         = google_vpc_access_connector.connector.id
    environment_variables = {
      DB_NAME  = var.db-name
      DB_PWD   = random_password.password.result
      DB_USER  = var.db-username
      DB_HOST  = google_sql_database_instance.db-instance.private_ip_address
      WEB_PORT = var.web-port
      DB_PORT  = var.db-port
    }
  }

  event_trigger {
    trigger_region = var.region
    event_type     = var.cf-event_type
    pubsub_topic   = google_pubsub_topic.webapp_pub_sub.id
    retry_policy   = var.cf-retry_policy
    # service_account_email = google_service_account.google_service_acc.email
  }
}

resource "google_pubsub_topic" "webapp_pub_sub" {
  name                       = var.pubsub-topicName
  message_retention_duration = var.pubsub-message_retention_duration
}

resource "google_pubsub_topic_iam_binding" "bindingPubSub" {
  topic   = google_pubsub_topic.webapp_pub_sub.name
  role    = var.pubsub-role
  members = [google_service_account.google_service_acc.member]
}

resource "google_cloudfunctions2_function_iam_binding" "bindingCF1" {
  location       = google_cloudfunctions2_function.cloudFunction.location
  cloud_function = google_cloudfunctions2_function.cloudFunction.name
  role           = var.cf-role1
  members        = [google_service_account.google_service_acc.member]
}

resource "google_cloudfunctions2_function_iam_binding" "bindingCF2" {
  location       = google_cloudfunctions2_function.cloudFunction.location
  cloud_function = google_cloudfunctions2_function.cloudFunction.name
  role           = var.cf-role2
  members        = [google_service_account.google_service_acc.member]
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vac-name
  ip_cidr_range = var.vac-ip_cidr_range
  network       = google_compute_network.vpc_network.id
  machine_type  = var.vac-machine_type
}