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
