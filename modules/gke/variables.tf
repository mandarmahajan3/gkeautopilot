variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "network" {
  description = "The VPC network name where the GKE cluster will be deployed."
  type        = string
}

variable "subnetwork" {
  description = "The VPC subnetwork name where the GKE cluster will be deployed."
  type        = string
}

variable "authorized_network" {
  description = "The CIDR block for the authorized network that can access the GKE master."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the GKE master."
  type        = string
}

variable "namespaces" {
  description = "A list of namespaces to be created in the Kubernetes cluster."
  type        = list(string)
}

variable "ingress_service_name" {
  description = "The service name for the Kubernetes Ingress resource."
  type        = string
}

variable "ingress_service_port" {
  description = "The service port for the Kubernetes Ingress resource."
  type        = number
}

variable "internal_cidrs" {
  description = "A list of internal CIDRs that are allowed ingress."
  type        = list(string)
}

variable "allowed_cidr" {
  description = "A CIDR block that is allowed ingress from outside."
  type        = string
}
