terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.40.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
  backend "gcs" {
    bucket = "your-terraform-state-bucket"
    prefix = "dev/terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke" {
  source       = "../../module/GKE"
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
  network      = var.network
  subnetwork   = var.subnetwork
}


module "namespace" {
  source = "../../modules/namespace"

  namespaces           = var.namespaces
  ingress_service_name = var.ingress_service_name
  ingress_service_port = var.ingress_service_port
  internal_cidrs       = var.internal_cidrs
  allowed_cidr         = var.allowed_cidr
}



module "cloudsql" {
  source                = "../../module/CloudSQL"
  project               = var.project_id
  region                = var.region
  db_name               = var.db_name
  machine_type          = var.machine_type
  db_password_secret_id = var.db_password_secret_id
}

module "artifact_registry" {
  source    = "../../module/ArtifactRegistry"
  project_id = var.project_id
  region    = var.region
  repo_name = var.repo_name
}
