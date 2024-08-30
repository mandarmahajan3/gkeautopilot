# Variables for the Cloud SQL instance

# Project ID where the resources will be created
variable "project_id" {
  description = "The ID of the project in which to create the Cloud SQL instance."
  type        = string
}

# Cloud SQL instance name
variable "instance_name" {
  description = "The name of the Cloud SQL instance."
  type        = string
}

# Region where the Cloud SQL instance will be deployed
variable "region" {
  description = "The region to deploy the Cloud SQL instance."
  type        = string
  default     = "us-central1"
}

# Database version for the Cloud SQL instance
variable "database_version" {
  description = "The database version for the Cloud SQL instance."
  type        = string
  default     = "MYSQL_8_0"
}

# Database tier (machine type) for the Cloud SQL instance
variable "db_tier" {
  description = "The machine type (tier) for the Cloud SQL instance."
  type        = string
  default     = "db-f1-micro"
}

# Whether to enable deletion protection for the Cloud SQL instance
variable "deletion_protection" {
  description = "Whether deletion protection is enabled for the Cloud SQL instance."
  type        = bool
  default     = true
}

# Master user name for the Cloud SQL instance
variable "db_username" {
  description = "The name of the master user for the Cloud SQL instance."
  type        = string
  default     = "master_user"
}
