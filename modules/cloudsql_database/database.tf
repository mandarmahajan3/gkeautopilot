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

# Store the master user password in Secret Manager
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

# Create the DDL user
resource "google_sql_user" "ddl_user" {
  name     = "ddl_user"
  instance = var.instance_name
  password = random_password.ddl_user_password.result
  host     = "%"
}

resource "null_resource" "setup_permissions" {
  provisioner "local-exec" {
    command = <<EOT
    # Run Cloud SQL Proxy
    ./cloud_sql_proxy -dir=/cloudsql -instances=${var.project_id}:${var.region}:${var.instance_name}=tcp:3306 &

    # Wait for the proxy to start
    sleep 10

    # Grant permissions using mysql
    mysql -u root -p"${random_password.master_user_password.result}" \
    -h 127.0.0.1 -P 3306 -D "${var.database_name}" -e "
    GRANT SELECT, INSERT, UPDATE, DELETE ON ${var.database_name}.* TO 'dml_user'@'%';
    GRANT CREATE, ALTER, DROP ON ${var.database_name}.* TO 'ddl_user'@'%';
    "

    # Kill the Cloud SQL Proxy
    pkill cloud_sql_proxy
    EOT
  }

  depends_on = [
    google_sql_user.master_user,
    google_sql_user.dml_user,
    google_sql_user.ddl_user
  ]
}





# Outputs
output "cloudsql_instance_public_ip" {
  value = data.google_sql_database_instance.instance.public_ip_address
}

output "cloudsql_instance_private_ip" {
  value = data.google_sql_database_instance.instance.private_ip_address
}
