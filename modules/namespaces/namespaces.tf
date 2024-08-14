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
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/*" # or /${each.value.metadata[0].name}
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = each.value.metadata[0].name
              port {
                number = var.ingress_service_port
              }
            }
          }
        }
      }
    }
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
      dynamic "from" {
        for_each = var.allowed_cidrs
        content {
          ip_block {
            cidr = from.value
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
  depends_on = [kubernetes_namespace.namespace]
}

resource "kubernetes_service_account" "namespace_service_accounts" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = "${each.key}-sa"
    namespace = each.value.metadata[0].name
  }
}

resource "kubernetes_service_v1" "namespace_service" {
  for_each = kubernetes_namespace.namespace

  metadata {
    name      = each.key  # Use the namespace name as the service name
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

