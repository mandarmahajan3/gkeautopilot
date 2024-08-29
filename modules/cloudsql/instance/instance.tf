# Create Cloud SQL instance with HA and PSC enabled
resource "google_sql_database_instance" "instance" {
  name             = var.instance_name
  region           = var.region
  database_version = var.db_version
  project          = var.project_id
  deletion_protection = false

  settings {
    tier            = var.db_tier
    edition         = "ENTERPRISE_PLUS"
    availability_type = "REGIONAL"  # Enable HA

    data_cache_config {
        data_cache_enabled = true
    }

    ip_configuration {
      ssl_mode    = "ENCRYPTED_ONLY"
      ipv4_enabled = false
      psc_config {
        psc_enabled = true
        allowed_consumer_projects = var.allowed_consumer_projects
      }
    }

    database_flags {
      name  = "lower_case_table_names"
      value = "1"
    }
    database_flags {
      name  = "sql_mode"
      value = "NO_ENGINE_SUBSTITUTION"
    }
    database_flags {
      name  = "character_set_server"
      value = "latin1"
    }
    database_flags {
      name  = "explicit_defaults_for_timestamp"
      value = "off"
    }
    database_flags {
      name  = "cloudsql_iam_authentication"
      value = "on"  
    }
  }
}


# Create read replica
resource "google_sql_database_instance" "replica" {
  name               = "${var.instance_name}-replica"
  region             = var.region
  project            = var.project_id
  deletion_protection = false
  database_version    = var.db_version
  master_instance_name = google_sql_database_instance.instance.name

  settings {
    tier            = var.db_tier
    availability_type = "REGIONAL"  # HA for replica as well

    ip_configuration {
      ipv4_enabled = false
    }
  }
}
