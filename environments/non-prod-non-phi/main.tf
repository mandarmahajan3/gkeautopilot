



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
  source             = "modules/cloudsql_database"
  database_name      = var.database_name # Passing database_name variable
  instance_name      = module.cloudsql_instance.instance_name
  db_username        = var.db_username # Passing db_username variable
}
