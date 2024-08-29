variable "project_id" {
  type        = string
  description = "The ID of the GCP project"
}

variable "region" {
  type        = string
  description = "The region where the Cloud SQL instance will be created"
}

variable "database_name" {
  type        = string
  description = "Name of the database to create"
}
variable "instance_name" {
  type        = string
  description = "Name of the database to create"
}

variable "db_username" {
  type        = string
  description = "The master username for the database"
}

