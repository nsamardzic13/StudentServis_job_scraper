resource "google_service_account" "service_account" {
  account_id   = var.gcp_project
  display_name = "${var.project_name}-service-account"
}

resource "google_project_iam_member" "cloud_run_admin" {
  project = var.gcp_project
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "cloud_scheduler_admin" {
  project = var.gcp_project
  role    = "roles/cloudscheduler.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "cloud_run_service_account_user" {
  project = var.gcp_project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
