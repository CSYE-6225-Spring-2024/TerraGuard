
data "google_storage_bucket" "nameOfBucket" {
  name = "csye6225-serverless-cf"
}
data "google_storage_bucket_object" "storageBucketObj" {
  bucket = data.google_storage_bucket.nameOfBucket.name
  name   = "serverless.zip"
}

resource "google_cloudfunctions2_function" "cloudFunction" {
  name     = var.cf-name
  location = var.region
  build_config {
    runtime     = var.cf-runtime
    entry_point = var.cf-entrypoint

    source {
      storage_source {
        bucket = data.google_storage_bucket.nameOfBucket.name
        object = data.google_storage_bucket_object.storageBucketObj.name
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

  event_trigger {
    trigger_region        = var.region
    event_type            = var.cf-event_type
    pubsub_topic          = google_pubsub_topic.webapp_pub_sub.id
    retry_policy          = var.cf-retry_policy
    service_account_email = google_service_account.google_service_acc_emailing.email
  }
}

resource "google_pubsub_topic" "webapp_pub_sub" {
  name                       = var.pubsub-topicName
  message_retention_duration = var.pubsub-message_retention_duration
}
resource "google_service_account" "google_service_acc_emailing" {
  account_id = var.google_service_accountID_emailing
}

resource "google_project_iam_binding" "role-pubsub-publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  members = [google_service_account.google_service_acc.member]
}

# resource "google_pubsub_topic_iam_binding" "role-pubsub-viewer" {
#   topic   = google_pubsub_topic.webapp_pub_sub.name
#   role    = "roles/viewer"
#   members = [google_service_account.google_service_acc.member, google_service_account.google_service_acc_emailing.member]
# }

# resource "google_cloudfunctions2_function_iam_binding" "role-cf-viewer" {
#   location       = google_cloudfunctions2_function.cloudFunction.location
#   cloud_function = google_cloudfunctions2_function.cloudFunction.name
#   role           = "roles/viewer"
#   members        = [google_service_account.google_service_acc_emailing.member]
# }

# resource "google_cloudfunctions2_function_iam_binding" "bindingCF2" {
#   location       = google_cloudfunctions2_function.cloudFunction.location
#   cloud_function = google_cloudfunctions2_function.cloudFunction.name
#   role           = var.cf-role2
#   members        = [google_service_account.google_service_acc_emailing.member]
# }

resource "google_service_account_iam_binding" "role-token-creater" {
  service_account_id = google_service_account.google_service_acc_emailing.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members = [
    google_service_account.google_service_acc_emailing.member
  ]
  depends_on = [ google_service_account.google_service_acc_emailing ]
}

resource "google_project_iam_binding" "role-cf-invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  members = [google_service_account.google_service_acc_emailing.member]
  depends_on = [google_service_account.google_service_acc_emailing]
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vac-name
  ip_cidr_range = var.vac-ip_cidr_range
  network       = google_compute_network.vpc_network.id
  machine_type  = var.vac-machine_type
}