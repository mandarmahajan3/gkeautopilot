provider "kubernetes" {
  config_path           = "~/.kube/config"
  config_context_cluster = var.k8s_cluster_name
}

resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }
}

resource "kubernetes_ingress" "namespace_ingress" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "${each.value}-ingress"
    namespace = each.value
  }

  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = var.ingress_service_name
            service_port = var.ingress_service_port
          }
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "deny_all_ingress" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "deny-all-ingress"
    namespace = each.value
  }

  spec {
    pod_selector {}

    ingress {
      from {
        ip_block {
          cidr   = "0.0.0.0/0"
          except = concat(var.internal_cidrs, [var.allowed_cidr])
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy" "allow_all_internal_ingress" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "allow-all-internal-ingress"
    namespace = each.value
  }

  spec {
    pod_selector {}

    ingress {
      from {
        ip_block {
          cidr = var.internal_cidrs
        }
      }
      from {
        ip_block {
          cidr = var.allowed_cidr
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_service_account" "namespace_service_accounts" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "${each.value}-sa"
    namespace = each.value
  }
}
