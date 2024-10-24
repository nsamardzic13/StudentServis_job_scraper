resource "google_cloud_run_v2_job" "cloud_run" {
  name     = "${var.project_name}-cloudrun"
  location = var.region
  template {
    template {
      containers {
        image = var.image_name
        resources {
          limits = {
            "cpu"    = "1"
            "memory" = "512Mi"
          }
        }
      }
      service_account = google_service_account.service_account.email
    }
  }
}

resource "google_cloud_scheduler_job" "cloud_run_scheduler" {
  name     = "${var.project_name}-scheduler"
  project  = var.gcp_project
  schedule = "30 8 * * 1-5" # 3 PM UTC every weekday (Monday to Friday)

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/v2/projects/${var.gcp_project}/locations/${var.region}/jobs/${google_cloud_run_v2_job.cloud_run.name}:run"
    oidc_token {
      service_account_email = google_service_account.service_account.email
    }
  }

  time_zone = "UTC"
}