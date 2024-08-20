#Create a module for single database instance creation. 

# Generate a unique password for each environment
resource "random_password" "db_password" {
  length   = 16
  special  = true
}

# Create the database for each environment
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = var.instance_name
}

# Create the master user for each database
resource "google_sql_user" "master_user" {
  name     = var.db_username
  instance = var.instance_name
  password = random_password.db_password.result
}

# Store the master user password in GCP Secret Manager
resource "google_secret_manager_secret" "db_master_secret" {

  secret_id = "${var.instance_name}-db-master-password"
  
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-central1"
      }
    }
  }
}

# Store the password in Secret Manager
resource "google_secret_manager_secret_version" "db_master_secret_version" {
   secret      = google_secret_manager_secret.db_master_secret.id
  secret_data = random_password.db_password.result
}
