provider "google" {
  project = var.project_name
  region = var.default_region
}

resource "google_project_service" "project" {
  for_each = toset(var.project_apis)
  project = var.project_name
  service = each.value
}

module "service_accounts" {
  depends_on = [
    google_project_service.project
  ]
  source = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"
  project_id = var.project_name
  prefix = "test-sa"
  names = [
    "k8s-builder"]
  project_roles = [
    "${var.project_name}=>roles/container.clusterAdmin",
    "${var.project_name}=>roles/container.developer",
    "${var.project_name}=>roles/compute.instanceAdmin",
  ]
}

resource "google_container_cluster" "test-cluster" {
  depends_on = [
    google_project_service.project,
    module.service_accounts,
  ]
  name = "test-cluster"
  location = "${var.default_region}-c"
  initial_node_count = 1
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = module.service_accounts.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = [
      "foo",
      "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

data "google_service_account_access_token" "my_kubernetes_sa" {
  target_service_account = module.service_accounts.email
  scopes = [
    "userinfo-email",
    "cloud-platform"]
  lifetime = "3600s"
}
