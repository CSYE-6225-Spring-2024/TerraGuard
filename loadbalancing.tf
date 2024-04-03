module "gce-lb-http" {
  source                          = "terraform-google-modules/lb-http/google"
  version                         = "~> 10.0"
  name                            = var.lb-name
  project                         = var.project_id
  http_forward                    = false
  target_tags                     = var.webapp-inst-tags
  firewall_networks               = [google_compute_network.vpc_network.name]
  ssl                             = true
  managed_ssl_certificate_domains = var.lb-managed_ssl_certificate_domains
  # ssl_certificates = [google_compute_ssl_certificate.ssl-certf.self_link]
  backends = {
    default = {
      protocol    = "HTTP"
      port        = var.web-port
      port_name   = var.mig-named_port
      timeout_sec = var.lb-backend-timeout_sec
      enable_cdn  = false
      health_check = {
        request_path        = var.webapp-health-check-request_path
        port                = var.web-port
        timeout_sec         = var.webapp-health-check-timeout_sec
        check_interval_sec  = var.webapp-health-check-check_interval_sec
        healthy_threshold   = var.webapp-health-check-healthy_threshold
        unhealthy_threshold = var.webapp-health-check-unhealthy_threshold
      }
      iap_config = {
        enable = false
      }
      groups = [
        {
          group = google_compute_region_instance_group_manager.webapp-mig.instance_group
        },
      ]
      log_config = {
        enable      = true
        sample_rate = 1.0
      }
    }
  }
}

# resource "google_compute_ssl_certificate" "ssl-certf" {
#   name_prefix = "webapp-certificate"
#   private_key = file("private.key")
#   certificate = file("safehubnest_me.crt")
#   lifecycle {
#     create_before_destroy = true
#   }
# }