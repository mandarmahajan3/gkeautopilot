# Data source to get the Cloud SQL instance information by name
data "google_sql_database_instance" "instance" {
  name    = var.instance_name
  project = var.project_id
}

# Generate unique passwords for each user
resource "random_password" "master_user_password" {
  length  = 16
  special = true
}

resource "random_password" "dml_user_password" {
  length  = 16
  special = true
}

resource "random_password" "ddl_user_password" {
  length  = 16
  special = true
}

# Create the master user for the database
resource "google_sql_user" "master_user" {
  name     = var.db_username
  instance = var.instance_name
  password = random_password.master_user_password.result
}

# Store the master user password in GCP Secret Manager
resource "google_secret_manager_secret" "db_master_secret" {
  secret_id = "${var.instance_name}-db-master-password"
  
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_master_secret_version" {
  secret      = google_secret_manager_secret.db_master_secret.id
  secret_data = random_password.master_user_password.result
}

# Create the DML user
resource "google_sql_user" "dml_user" {
  name     = "dml_user"
  instance = var.instance_name
  password = random_password.dml_user_password.result
  host     = "%"
}

# Store the DML user password in GCP Secret Manager
resource "google_secret_manager_secret" "dml_user_secret" {
  secret_id = "${var.instance_name}-dml-user-password"
  
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "dml_user_secret_version" {
  secret      = google_secret_manager_secret.dml_user_secret.id
  secret_data = random_password.dml_user_password.result
}

# Create the DDL user
resource "google_sql_user" "ddl_user" {
  name     = "ddl_user"
  instance = var.instance_name
  password = random_password.ddl_user_password.result
  host     = "%"
}

# Store the DDL user password in GCP Secret Manager
resource "google_secret_manager_secret" "ddl_user_secret" {
  secret_id = "${var.instance_name}-ddl-user-password"
  
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "ddl_user_secret_version" {
  secret      = google_secret_manager_secret.ddl_user_secret.id
  secret_data = random_password.ddl_user_password.result
}

# Create the Cloud SQL instance
resource "google_sql_database_instance" "instance" {
  name             = var.instance_name
  region           = var.region
  database_version = "MYSQL_8_0"
  settings {
    tier = var.db_tier
  }

  deletion_protection = var.deletion_protection
}

# Outputs
output "cloudsql_instance_public_ip" {
  value = data.google_sql_database_instance.instance.public_ip_address
}

output "cloudsql_instance_private_ip" {
  value = data.google_sql_database_instance.instance.private_ip_address
}
