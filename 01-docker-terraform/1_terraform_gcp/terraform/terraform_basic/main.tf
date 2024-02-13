terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project     = "naujas-349314"
  region      = "us-central1"
}



resource "google_storage_bucket" "demo-bucket" {
  name     = "naujas-349314-terra-bucket"
  location = "EU"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "AbortIncompleteMultipartUpload"
    }
    condition {
      age = 1 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "demo_dataset"
  project    = "naujas-349314"
  location   = "US"
}