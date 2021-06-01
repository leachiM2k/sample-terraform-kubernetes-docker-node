terraform {
  backend "gcs" {
    bucket = "tfstate-bucket-ea165c13"
    prefix = "terraform/state"
  }
}
