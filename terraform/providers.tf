terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.69"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}