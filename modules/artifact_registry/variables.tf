variable "project_id" {
  description = "The GCP project ID in which to create the Artifact Registry."
  type        = string
}

variable "region" {
  description = "The region in which to deploy the Artifact Registry."
  type        = string
  default     = "us-central1"
}

variable "repository_name" {
  description = "The name of the Artifact Registry repository."
  type        = string
}

variable "repository_format" {
  description = "The format of the repository (e.g., DOCKER, MAVEN, NPM, etc.)."
  type        = string
  default     = "DOCKER"  # Replace with the format you need
}

variable "repository_description" {
  description = "The description of the repository."
  type        = string
  default     = "A description for the Artifact Registry repository."
}

variable "labels" {
  description = "Labels to apply to the Artifact Registry repository."
  type        = map(string)
  default     = {}
}

variable "artifact_viewer_member" {
  description = "The IAM member to grant read access to the Artifact Registry."
  type        = string
  default     = "allAuthenticatedUsers"  # Update this as needed
}
