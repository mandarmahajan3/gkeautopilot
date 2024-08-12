provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "artifact_repo" {
  provider = google

  name         = var.repository_name
  format       = var.repository_format
  location     = var.region
  description  = var.repository_description

  labels = var.labels
}

resource "google_artifact_registry_repository_iam_member" "artifact_repo_viewer" {
  repository = google_artifact_registry_repository.artifact_repo.id
  role       = "roles/artifactregistry.reader"
  member     = var.artifact_viewer_member
}
