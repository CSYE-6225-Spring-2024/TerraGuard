resource "google_storage_bucket" "bucket-webapp" {
  name                        = "cf-bucket-csye6225"
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object-webapp" {
  name   = "serverless.zip"
  bucket = google_storage_bucket.bucket-webapp.name
  source = "serverless.zip" # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "cloudFunction" {
  name     = "cf-webapp"
  location = var.region
  build_config {
    runtime     = "nodejs18"
    entry_point = "sendEmail"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket-webapp.name
        object = google_storage_bucket_object.object-webapp.name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    available_memory      = "256M"
    timeout_seconds       = 60
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
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.webapp_pub_sub.id
    retry_policy   = "RETRY_POLICY_RETRY"
    # service_account_email = google_service_account.google_service_acc.email
  }
}

resource "google_pubsub_topic" "webapp_pub_sub" {
  name                       = "verify_email"
  message_retention_duration = "604800s"
}

resource "google_pubsub_topic_iam_binding" "bindingPubSub" {
  topic   = google_pubsub_topic.webapp_pub_sub.name
  role    = "roles/pubsub.publisher"
  members = [google_service_account.google_service_acc.member]
}

resource "google_cloudfunctions2_function_iam_binding" "bindingCF1" {
  location       = google_cloudfunctions2_function.cloudFunction.location
  cloud_function = google_cloudfunctions2_function.cloudFunction.name
  role           = "roles/viewer"
  members        = [google_service_account.google_service_acc.member]
}

resource "google_cloudfunctions2_function_iam_binding" "bindingCF2" {
  location       = google_cloudfunctions2_function.cloudFunction.location
  cloud_function = google_cloudfunctions2_function.cloudFunction.name
  role           = "roles/cloudfunctions.invoker"
  members        = [google_service_account.google_service_acc.member]
}

resource "google_vpc_access_connector" "connector" {
  name          = "vpc-access-conn-webapp"
  ip_cidr_range = "10.11.2.0/28"
  network       = google_compute_network.vpc_network.id
  machine_type  = "e2-standard-4"
}