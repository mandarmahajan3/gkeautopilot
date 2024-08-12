# GCP Project and Region
project_id = "your-prod-project-id"
region     = "us-central1"  # Update this to the region you want

# GKE Cluster
cluster_name    = "prod-gke-cluster"
network         = "your-vpc-network"       # Replace with your VPC network name
subnetwork      = "your-vpc-subnetwork"    # Replace with your VPC subnetwork name
authorized_network = "your-authorized-network-cidr"  # Replace with your authorized network CIDR block

# CloudSQL
name_prefix         = "prod-mysql-instance"
name_override       = null  # Set this to a specific name if you want to override the default name
db_name             = "prod_db"
mysql_version       = "MYSQL_8_0"  # Update if needed
machine_type        = "db-n1-standard-1"  # Update the machine type as per your requirement
master_user_password = "your-secure-password"
master_user_name    = "admin"
require_ssl         = true

#Cloud Registry
repository_name      = "prod-artifact-repo"
repository_format    = "DOCKER"
repository_description = "Production Artifact Registry for Docker images"
labels = {
  environment = "prod"
}
artifact_viewer_member = "user:you@example.com"  # Replace with the correct IAM member
