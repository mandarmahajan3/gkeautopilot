variable "project" {
  description = "The GCP project in which to create the resources."
  type        = string
}

variable "region" {
  description = "The region in which to deploy the Cloud SQL instance."
  type        = string
  default     = "us-central1" # or specify the preferred default region
}

variable "name_prefix" {
  description = "Prefix to use for resource names. A random suffix will be appended."
  type        = string
  default     = "mysql-instance"
}

variable "name_override" {
  description = "Override the generated name with a custom name. If null, the generated name will be used."
  type        = string
  default     = null
}

variable "db_name" {
  description = "The name of the default database to create in the Cloud SQL instance."
  type        = string
}

variable "mysql_version" {
  description = "The MySQL version to use for the Cloud SQL instance."
  type        = string
  default     = "MYSQL_5_7" # or specify the preferred MySQL version
}

variable "machine_type" {
  description = "The machine type to use for the Cloud SQL instance."
  type        = string
  default     = "db-f1-micro" # or specify the preferred machine type
}

variable "master_user_password" {
  description = "The password for the master user of the database."
  type        = string
  sensitive   = true
}

variable "master_user_name" {
  description = "The username for the master user of the database."
  type        = string
  default     = "root"
}

variable "require_ssl" {
  description = "Enforce SSL connections to the Cloud SQL instance."
  type        = bool
  default     = true
}
