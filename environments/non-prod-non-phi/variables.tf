variable "project_id" {
  description = "The project ID to deploy the GKE cluster"
  type        = string
}

variable "region" {
  description = "The region where the GKE cluster will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "network" {
  description = "The network to which the GKE cluster will be connected"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to which the GKE cluster will be connected"
  type        = string
}

variable "authorized_network" {
  description = "The CIDR block authorized to access the cluster's control plane"
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The CIDR block for the master network in the GKE cluster"
  type        = string
}


variable "namespaces" {
  description = "A list of namespaces to create in the Kubernetes cluster"
  type        = list(string)
}

variable "ingress_service_name" {
  description = "The name of the service to be used in the ingress configuration"
  type        = string
}

variable "ingress_service_port" {
  description = "The port of the service to be used in the ingress configuration"
  type        = number
}

variable "internal_cidrs" {
  description = "List of internal CIDRs for network policies"
  type        = list(string)
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/8", "192.168.0.0/16"]  # Example CIDRs
}
