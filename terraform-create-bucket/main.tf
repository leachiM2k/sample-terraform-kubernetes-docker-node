provider "google" {
  project = var.project_name
  region = var.default_region
}

resource "random_id" "suffix" {
  byte_length               = 4
}

resource "google_storage_bucket" "state-bucket" {
  name     = "tfstate-bucket-${random_id.suffix.hex}"
  location = var.default_region

  versioning {
    enabled = true
  }
}
