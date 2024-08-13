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

#code

module "gke" {
  source                  = "../../module/GKE"
  project_id              = var.project_id
  region                  = var.region
  cluster_name            = var.cluster_name
  network                 = var.network
  subnetwork              = var.subnetwork
  authorized_network      = var.authorized_network
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block
}

module "namespace" {
  source                 = "../../modules/namespace"
  namespaces             = var.namespaces
  ingress_service_name   = var.ingress_service_name
  ingress_service_port   = var.ingress_service_port
  internal_cidrs         = var.internal_cidrs
  allowed_cidr           = var.allowed_cidr
}
