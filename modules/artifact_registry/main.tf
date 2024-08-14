provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_artifact_registry_repository" "artifact_repo" {
  repository_id = var.repository_name
  format       = "DOCKER"
  location     = var.region
  description  = "Repository for Cirrus Apps"
  cleanup_policy_dry_run = false
  cleanup_policies {
    id     = "keep-tagged-release"
    action = "KEEP"
    condition {
      tag_state             = "TAGGED"
      tag_prefixes          = [
        "cirrusdev",
        "cirrusalpha",
        "cirrusbravo",
        "cirrusmaster"]
    }
  }
}

resource "google_artifact_registry_repository_iam_member" "artifact_repo_viewer" {
  repository = google_artifact_registry_repository.artifact_repo.repository_id
  role         = "roles/artifactregistry.reader"
  member       = var.artifact_viewer_member

  depends_on = [ google_artifact_registry_repository.artifact_repo ]
}
