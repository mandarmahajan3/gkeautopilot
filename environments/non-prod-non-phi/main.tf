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
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Define the GKE module
/*
module "gke" {
  source                 = "../../modules/gke"
  project_id             = var.project_id
  region                 = var.region
  cluster_name           = var.cluster_name
  network                = var.network
  subnetwork             = var.subnetwork
  authorized_network     = var.authorized_network
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
}

# Define the Kubernetes provider using outputs from the GKE module
provider "kubernetes" {
  host                   = "https://${module.gke.cluster_endpoint}"
  token                  = module.gke.access_token
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
}

# Outputs
output "cluster_location" {
  value = module.gke.cluster_location
}

module "namespace" {
  source                 = "../../modules/namespaces"
  namespaces             = var.namespaces
  ingress_service_name   = var.ingress_service_name
  ingress_service_port   = var.ingress_service_port
  internal_cidrs         = var.internal_cidrs
  allowed_cidrs           = var.allowed_cidrs
}


# Artifact Registry 

module "artifact_registry" {
  source  = "../../modules/artifact_registry"  # Adjust the path to your module
  project_id    = var.project_id
  region         = var.region
  repository_name = var.repository_name
  artifact_viewer_member = var.artifact_viewer_member
}


*/
# Main Module

module "cloudsql_instance" {
  source             = "../../modules/cloudsql_instance"
  instance_name      = var.instance_name
  region             = var.region
  db_version         = var.db_version
  project_id         = var.project_id
  db_tier            = var.db_tier
  allowed_consumer_projects = var.allowed_consumer_projects
}

module "cloudsql_database" {
  source             = "../../modules/cloudsql_database"
  database_name      = var.database_name
  instance_name      = module.cloudsql_instance.instance_name
  db_username        = var.db_username
}
