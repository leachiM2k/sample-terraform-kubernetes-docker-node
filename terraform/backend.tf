terraform {
  backend "gcs" {
    bucket = "tfstate-bucket-ea165c13"
    prefix  = "terraform/state"
    project = var.project_name
    region = var.default_region
  }
}
