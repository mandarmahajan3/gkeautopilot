
/*

module "cloudsql_instance" {
  source             = "../../modules/cloudsql_instance"
  instance_name      = var.instance_name
  region             = var.region
  db_version         = var.db_version
  project_id         = var.project_id
  db_tier            = var.db_tier
  allowed_consumer_projects = var.allowed_consumer_projects
}

module "cloudsql_database" {
  source             = "../../modules/cloudsql_database"
  region             = var.region
  project_id         = var.project_id
  database_name      = var.database_name # Passing database_name variable
  instance_name      = var.instance_name
  db_username        = var.db_username # Passing db_username variable

  depends_on = [ module.cloudsql_instance ]
}
*/

# Call the HA Cloud SQL instance module
module "ha_cloud_sql_instance" {
  source = "./modules/cloudsql_instance"

  project_id                = var.project_id
  region                    = var.region
  db_version                = var.db_version
  db_tier                   = var.db_tier
  instance_name             = var.instance_name
  allowed_consumer_projects = var.allowed_consumer_projects
  read_replica_regions      = var.read_replica_regions

  # Backup configuration
  backup_configuration = var.backup_configuration

  # Edition (set to "ENTERPRISE_PLUS" in your variables.tf)
  edition = var.edition
}