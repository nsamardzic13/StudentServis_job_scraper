terraform {
  backend "gcs" {
    bucket      = "tf-my-backend-bucket"
    prefix      = "studentservis_job_scraper/"
    credentials = "service_account.json"
  }
}