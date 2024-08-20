
# Create Cloud SQL instance for each namespace with PSC enabled
resource "google_sql_database_instance" "instance" {

  name             = var.instance_name
  region           = var.region
  database_version = var.db_version
  project          = var.project_id
  deletion_protection = false


  settings {
    tier = var.db_tier

    ip_configuration {
      ssl_mode = "ENCRYPTED ONLY"
      ipv4_enabled = "false"
      psc_config {
        psc_enabled = true
        allowed_consumer_projects = var.allowed_consumer_projects
      }
    }
  database_flags {
    name = "lower_case_table_names"
    value = "1"
  }
  database_flags {
    name = "sql_mode"
    value = "NO_ENGINE_SUBSTITUTION"
  }
  database_flags {
    name = "character_set_server"
    value = "latin1"
  }      
  database_flags {
    name = "explicit_defaults_for_timestamp"
    value = "off"
  }
  }
}