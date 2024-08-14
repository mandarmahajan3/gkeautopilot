resource "kubernetes_namespace" "namespace" {
  for_each = { for ns in var.namespaces : ns => ns }
  metadata {
    name = each.value
  }
}

resource "kubernetes_ingress_v1" "namespace_ingress" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = "${each.value.metadata[0].name}-ingress"
    namespace = each.value.metadata[0].name
  }

  spec {
    default_backend {
      service {
        name = var.ingress_service_name
        port {
          number = var.ingress_service_port
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = var.ingress_service_name
              port {
                number = var.ingress_service_port
              }
            }
          }

          path = "/*"
        }
      }
    }

    # Optional: Configure TLS if needed
    # tls {
    #   secret_name = "tls-secret"
    # }
  }
  depends_on = [kubernetes_namespace.namespace]
}



resource "kubernetes_network_policy" "deny_all" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = "${each.value.metadata[0].name}-deny-all"
    namespace = each.value.metadata[0].name
  }

  spec {
    pod_selector {}

    ingress {
      from {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }
    }

    policy_types = ["Ingress"]
  }
  depends_on = [kubernetes_namespace.namespace]
}

resource "kubernetes_network_policy" "allow_selected_cidrs" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = "${each.value.metadata[0].name}-allow-selected-cidrs"
    namespace = each.value.metadata[0].name
  }

  spec {
    pod_selector {}

    ingress {
      from {
        dynamic "ip_block" {
          for_each = var.allowed_cidrs
          content {
            cidr = ip_block.value
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
  depends_on = [kubernetes_namespace.namespace]

}

resource "kubernetes_service_account" "namespace_service_accounts" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "${each.key}-sa"
    namespace = each.value
  }
}


resource "kubernetes_service_v1" "namespace_service" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = var.ingress_service_name
    namespace = each.value.metadata[0].name
  }

  spec {
    selector = {
      app = "myapp-${each.key}"
    }
    session_affinity = "ClientIP"
    port {
      port        = var.ingress_service_port
      target_port = 80
    }

    type = "NodePort"
  }
  depends_on = [kubernetes_ingress_v1.namespace_ingress]
}

resource "kubernetes_pod_v1" "namespace_pod" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = "terraform-${each.value.metadata[0].name}-pod"
    namespace = each.value.metadata[0].name
    labels = {
      app = "myapp-${each.key}"
    }
  }

  spec {
    container {
      image = "nginx:1.21.6"
      name  = "example"

      port {
        container_port = 80
      }
    }
  }
}