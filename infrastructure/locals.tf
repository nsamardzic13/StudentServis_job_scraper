locals {
  credentials_file      = file("${var.credentials}")
  raw_credentials       = jsondecode(local.credentials_file)
  service_account_email = local.raw_credentials.client_email
}
