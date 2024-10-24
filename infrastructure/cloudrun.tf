resource "google_cloud_run_v2_service" "cloud_run" {
  name     = "${var.project_name}-cloudrun"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_INTERNAL_ONLY"

  template {
    containers {
      image = var.image_name
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          "cpu"    = "1"
          "memory" = "512Mi"
        }
      }
    }
    scaling {
      max_instance_count = 1
    }
    service_account = google_service_account.service_account.email
  }
}

resource "google_cloud_scheduler_job" "cloud_run_scheduler" {
  name     = "${var.project_name}-scheduler"
  project  = var.gcp_project
  schedule = "50 7 * * 1-5" # 3 PM UTC every weekday (Monday to Friday)

  http_target {
    http_method = "POST"
    uri         = google_cloud_run_v2_service.cloud_run.uri
    oidc_token {
      service_account_email = google_service_account.service_account.email
    }
  }

  time_zone = "UTC"
}