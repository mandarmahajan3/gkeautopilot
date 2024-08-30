# Kubernetes Namespaces and Related Resources Configuration

This document outlines the Terraform configuration for creating Kubernetes namespaces and the associated resources within those namespaces. These resources include ingress rules, network policies, service accounts, services, and pods.

## Kubernetes Namespaces

### Variables

- **`var.namespaces`**: A list of namespace names to be created.

### Resource Details

- **`kubernetes_namespace.namespace`**: Creates a Kubernetes namespace for each entry in the `var.namespaces` variable.

## Kubernetes Ingress

### Variables

- **`var.ingress_service_port`**: The port number for the ingress service backend.

### Resource Details

- **`kubernetes_ingress_v1.namespace_ingress`**: Configures an ingress resource for each namespace.
  - **`metadata.annotations["kubernetes.io/ingress.class"]`**: Specifies the ingress controller class to use, in this case, "nginx".
  - **`spec.rule.http.path.path`**: Defines the path for routing HTTP traffic, with `path_type` set to `ImplementationSpecific`.
  - **`spec.rule.http.path.backend.service.name`**: The service name used as the backend, which matches the namespace name.
  - **`spec.rule.http.path.backend.service.port.number`**: The port number for the backend service.

## Kubernetes Network Policies

### Resource Details

- **`kubernetes_network_policy.deny_all`**: Creates a network policy in each namespace to deny all ingress traffic by default.
  - **`spec.policy_types`**: Specifies the types of traffic (Ingress) to which the policy applies.
  - **`spec.ingress.from.ip_block.cidr`**: Restricts all ingress traffic using the `0.0.0.0/0` CIDR block.

- **`kubernetes_network_policy.allow_selected_cidrs`**: Creates a network policy to allow ingress traffic from specified CIDR blocks.
  - **`var.allowed_cidrs`**: List of CIDR blocks allowed to access the pods in each namespace.
  - **`spec.ingress.from.ip_block.cidr`**: Allows ingress traffic from the specified CIDR blocks.

## Kubernetes Service Accounts

### Resource Details

- **`kubernetes_service_account.namespace_service_accounts`**: Creates a service account in each namespace.
  - **`metadata.name`**: The name of the service account, suffixed with `-sa`.
  - **`metadata.namespace`**: The namespace in which the service account is created.

## Kubernetes Services

### Resource Details

- **`kubernetes_service_v1.namespace_service`**: Creates a service in each namespace.
  - **`metadata.name`**: The service name, which matches the namespace name.
  - **`spec.selector`**: Associates the service with pods having a label `app = "myapp-${each.key}"`.
  - **`spec.session_affinity`**: Configured as "ClientIP" for session persistence.
  - **`spec.port.port`**: The service port, defined by `var.ingress_service_port`.
  - **`spec.port.target_port`**: The target port for the service, set to `80`.
  - **`spec.type`**: The type of service, set to "NodePort".

## Kubernetes Pods

### Resource Details

- **`kubernetes_pod_v1.namespace_pod`**: Creates a pod in each namespace.
  - **`metadata.name`**: The pod name, prefixed with `terraform-` and suffixed with the namespace name.
  - **`metadata.labels`**: Associates the pod with a specific app using the `app` label.
  - **`spec.container.image`**: The container image to use, set to `nginx:1.21.6`.
  - **`spec.container.port.container_port`**: The port exposed by the container, set to `80`.

## Summary

This configuration allows for the automated creation and management of Kubernetes namespaces and associated resources like ingress controllers, network policies, services, and pods. By utilizing variables and a modular approach, the configuration can easily be adapted to different environments and requirements.
