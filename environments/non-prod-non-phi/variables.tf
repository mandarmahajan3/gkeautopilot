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


variable "repository_name" {
  description = "The name of the Artifact Registry repository."
  type        = string
}

variable "artifact_viewer_member" {
  description = "The member (email) that will be granted the `roles/artifactregistry.reader` role."
  type        = string
}

variable "db_version" {
  type        = string
  description = "The version of MySQL to use"
  default     = "MYSQL_5_7"
}

variable "db_tier" {
  type        = string
  description = "The machine type to use for the instance"
}

variable "database_name" {
  type        = string
  description = "Name of the database to create"
}

variable "db_username" {
  type        = string
  description = "The master username for the database"
}

variable "allowed_consumer_projects" {
  type        = list(string)
  description = "List of allowed consumer projects for PSC"
}
variable "instance_name" {
  type        = string
  description = "Name of the database to create"
}



variable "read_replica_regions" {
  type        = list(string)
  description = "Regions for the read replica"
}

variable "backup_configuration" {
  type = object({
    enabled                        = bool
    start_time                     = string
    binary_log_enabled             = bool
    point_in_time_recovery_enabled = bool
  })
  description = "Backup configuration settings"
}

variable "edition" {
  type        = string
  description = "The edition of the Cloud SQL instance"
  default     = "ENTERPRISE_PLUS"
}
