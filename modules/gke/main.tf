data "google_client_config" "default" {}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.40.0"  # Specify the version you need
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"  # Specify the version you need
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name                  = var.cluster_name
  location              = var.region
  enable_autopilot      = true
  deletion_protection   = false
  network               = var.network
  subnetwork            = var.subnetwork

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.authorized_network
    }
  }

  release_channel {
    channel = "STABLE"
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
}

output "cluster_location" {
  value = google_container_cluster.primary.location
}
