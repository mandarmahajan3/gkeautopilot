# Create a random password for the CloudSQL master user
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Create a secret in Google Secret Manager to store the master user password
resource "google_secret_manager_secret" "db_password_secret" {
  provider = google

  secret_id = "${var.name_prefix}-db-password"
  replication {
    automatic = true
  }
}

# Store the generated password in the secret
resource "google_secret_manager_secret_version" "db_password_secret_version" {
  provider = google

  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = random_password.db_password.result
}

# Retrieve the secret value from Google Secret Manager
data "google_secret_manager_secret_version" "db_password" {
  provider = google

  secret = google_secret_manager_secret.db_password_secret.id
  version = "latest"
}

# CREATE A RANDOM SUFFIX AND PREPARE RESOURCE NAMES
resource "random_id" "name" {
  byte_length = 2
}

locals {
  # If name_override is specified, use that - otherwise use the name_prefix with a random string
  instance_name = var.name_override == null ? format("%s-%s", var.name_prefix, random_id.name.hex) : var.name_override
}

module "mysql" {
  source = "github.com/gruntwork-io/terraform-google-sql.git//modules/cloud-sql?ref=v0.2.0"
  #source = "../../modules/cloud-sql"

  project = var.project
  region  = var.region
  name    = local.instance_name
  db_name = var.db_name

  engine       = var.mysql_version
  machine_type = var.machine_type

  # Use the secret value as the password
  master_user_password = data.google_secret_manager_secret_version.db_password.secret_data

  master_user_name = var.master_user_name
  master_user_host = "%"

  enable_public_internet_access = false
  deletion_protection           = false

  require_ssl = var.require_ssl

  authorized_networks = [
    {
      name  = "allow-all-inbound"
      value = "0.0.0.0/0"
    },
  ]

  database_flags = [
    {
      name  = "auto_increment_increment"
      value = "5"
    },
    {
      name  = "auto_increment_offset"
      value = "5"
    },
  ]

  custom_labels = {
    test-id = "mysql-public-ip-example"
  }
}
