provider "google" {
  project = var.project_name
  region = var.default_region
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_name
  prefix        = "test-sa"
  names         = ["k8s-builder"]
  project_roles = [
    "${var.project_name}=>roles/container.clusterAdmin",
    "${var.project_name}=>roles/container.developer",
    "${var.project_name}=>roles/iam.serviceAccountUser",
  ]
}

resource "google_container_cluster" "test-cluster" {
  name = "test-cluster"
  location = "europe-west1-c"
  initial_node_count = 3
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = module.service_accounts.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}
