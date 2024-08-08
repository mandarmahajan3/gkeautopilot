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


  # Public endpoint
  private_cluster_config {
    enable_private_nodes = false
  }
}

resource "google_container_node_pool" "primary_nodes" {
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_secret" "sa_secret" {
  metadata {
    name      = "sa-secret"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  data = {
    token = var.service_account_token
  }
}

resource "kubernetes_ingress" "dev_ingress" {
  metadata {
    name      = "dev-ingress"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = "example-service"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "ingress_default_deny" {
  metadata {
    name      = "ingress-default-deny"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
    ingress {
      from {}
    }
  }
}

resource "kubernetes_network_policy" "ingress_allow_namespace" {
  metadata {
    name      = "ingress-allow-namespace"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
    ingress {
      from {
        namespace_selector {}
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc_heapdump" {
  metadata {
    name      = "pvc-heapdump"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "1Ti"
      }
    }
    storage_class_name = "firestore-rwx-csi"
  }
}