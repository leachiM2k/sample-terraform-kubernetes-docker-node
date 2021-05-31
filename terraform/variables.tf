variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "project_name" {
  description = "GCP Project name"
  type        = string
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
}
