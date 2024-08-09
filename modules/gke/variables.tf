variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy GKE cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "network" {
  description = "The VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "The VPC subnetwork name"
  type        = string
}

variable "authorized_network" {
  description = "The authorized network CIDR block"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "The machine type for nodes"
  type        = string
  default     = "e2-medium"
}

variable "service_account_token" {
  description = "The service account token to be stored in the secret"
  type        = string
}

variable "k8s_cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "namespaces" {
  description = "List of namespaces to create."
  type        = list(string)
}

variable "internal_cidrs" {
  description = "CIDR blocks that are considered internal (e.g., VPC CIDRs)."
  type        = list(string)
}

variable "allowed_cidr" {
  description = "Specific CIDR block to allow through ingress."
  type        = string
}

variable "ingress_service_name" {
  description = "The name of the service to route ingress traffic to."
  type        = string
}

variable "ingress_service_port" {
  description = "The port on the service to route ingress traffic to."
  type        = number
}
