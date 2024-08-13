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
  name     = var.cluster_name
  location = var.region
  enable_autopilot = true
  network  = var.network
  subnetwork = var.subnetwork
  


  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.authorized_network
    }
  }

  release_channel {
    channel = "STABLE"
  }

 vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }


  # Public endpoint
  private_cluster_config {
    enable_private_nodes = true
  }
}

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  security_posture_config {
    mode               = "BASIC"
    vulnerability_mode = "VULNERABILITY_BASIC"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }
