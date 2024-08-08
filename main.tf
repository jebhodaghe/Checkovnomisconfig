provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name          = "your-unique-bucket-name"
  location      = "US"
  storage_class = "STANDARD"
  force_destroy = false

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  logging {
    log_bucket        = "logging-bucket"
    log_object_prefix = "log"
  }

  encryption {
    default_kms_key_name = "projects/your-gcp-project-id/locations/us/keyRings/your-key-ring/cryptoKeys/your-key"
  }

  labels = {
    environment = "production"
    team        = "devops"
  }

  public_access_prevention = "enforced"
}

# IAM policy to avoid overly permissive access
resource "google_storage_bucket_iam_member" "bucket_viewer" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "user:your-email@example.com"
}

resource "google_storage_bucket_iam_member" "bucket_admin" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:your-service-account@example.iam.gserviceaccount.com"
}
