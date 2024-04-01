module "gce-lb-http" {
  source                          = "terraform-google-modules/lb-http/google"
  version                         = "~> 10.0"
  name                            = "lb-webapp"
  project                         = var.project_id
  firewall_networks               = [google_compute_network.vpc_network.name]
  ssl                             = true
  managed_ssl_certificate_domains = ["safehubnest.me"]
  backends = {
    default = {
      protocol    = "HTTP"
      port        = 8080
      port_name   = "http"
      timeout_sec = 15
      enable_cdn  = false
      health_check = {
        request_path        = "/healthz"
        port                = 8080
        timeout_sec         = 5
        check_interval_sec  = 15
        healthy_threshold   = 3
        unhealthy_threshold = 3
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