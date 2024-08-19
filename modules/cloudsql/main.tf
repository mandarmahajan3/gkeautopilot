# Generate a unique password for each namespace
resource "random_password" "db_password" {
  for_each = { for ns in var.namespaces : ns => ns }
  length   = 16
  special  = true
}

# Create Cloud SQL instance for each namespace with PSC enabled
resource "google_sql_database_instance" "instance" {
  for_each = { for ns in var.namespaces : ns => ns }

  name             = "private-instance-${each.key}-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = var.db_version

  settings {
    tier = var.db_tier

    ip_configuration {
      psc_config {
        psc_enabled = true
        allowed_consumer_projects = var.allowed_consumer_projects
      }
    }
  }
}

# Create the database for each namespace
resource "google_sql_database" "database" {
  for_each = google_sql_database_instance.instance

  name     = var.database_name
  instance = google_sql_database_instance.instance[each.key].name
}

# Create the master user for each database
resource "google_sql_user" "master_user" {
  for_each = google_sql_database_instance.instance

  name     = var.db_username
  instance = google_sql_database_instance.instance[each.key].name
  password = random_password.db_password[each.key].result
}

# Store the master user password in GCP Secret Manager
resource "google_secret_manager_secret" "db_master_secret" {
  for_each = google_sql_database_instance.instance

  secret_id = "${each.key}-db-master-password"

  replication {
    auto {}
  }
}

# Store the password in Secret Manager
resource "google_secret_manager_secret_version" "db_master_secret_version" {
  for_each = google_secret_manager_secret.db_master_secret

  secret      = google_secret_manager_secret.db_master_secret[each.key].id
  secret_data = random_password.db_password[each.key].result
}
