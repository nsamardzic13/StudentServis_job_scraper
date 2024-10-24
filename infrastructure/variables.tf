variable "region" {
  type    = string
  default = "europe-west3"
}

variable "gcp_project" {
  type    = string
  default = "level-racer-394516"
}

variable "project_name" {
  description = "Default project_name"
  type        = string
  default     = "tf-ss-jobs"
}

variable "credentials" {
  description = "Path to service account file"
  type        = string
  default     = "./service_account.json"
}

variable "image_name" {
  type    = string
  default = "docker.io/nidjo13/ss-jobs:latest"
}