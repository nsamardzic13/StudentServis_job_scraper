variable "project_name" {
  description = "Default project_name"
  type        = string
  default     = "tf-ss-jobs"
}

variable "sns_email_address" {
  type    = string
  default = "nikola.samardzic1997+AWS@gmail.com"
}

variable "image_name" {
  type    = string
  default = "docker.io/nidjo13/ss-jobs:latest"
}