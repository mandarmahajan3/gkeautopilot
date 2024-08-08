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