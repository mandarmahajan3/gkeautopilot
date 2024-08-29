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

    backup_configuration {
      enabled                           = var.backup_configuration.enabled
      start_time                        = var.backup_configuration.start_time
      binary_log_enabled                = var.backup_configuration.binary_log_enabled
      }

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
/*
# Create a read replica for the Cloud SQL instance
resource "google_sql_database_instance" "read_replica" {
  count                = length(var.read_replica_regions)
  name                 = "${var.instance_name}-replica-${count.index + 1}"
  region               = element(var.read_replica_regions, count.index)
  master_instance_name = google_sql_database_instance.instance.name
  project              = var.project_id
  database_version     = var.db_version

  settings {
    tier    = var.db_tier
    edition = "ENTERPRISE_PLUS"
  }
}
*/



resource "google_sql_user" "iam_group_user" {
  name     = "GCP_CIRRUS_HCC_POC@groups.optum.com"
  instance = var.instance_name
  type     = "CLOUD_IAM_GROUP"
}



