# GCP Project and Region
project_id = "uhg-poc-432004"
region     = "us-central1"

# GKE Cluster
cluster_name           = "nonprod-nonphi"
network                = "default"
subnetwork             = "default"
authorized_network     = "0.0.0.0/0"
master_ipv4_cidr_block = "10.0.0.0/28"  # Adjust this as necessary

# Kubernetes Namespaces and Ingress Configuration
namespaces           = ["dev", "alpha"]  # Replace with your namespaces
ingress_service_name = "dev"  # Replace with your service name
ingress_service_port = 80  # Replace with your service port

# Network Policies
internal_cidrs = ["10.0.0.0/24", "10.1.0.0/24"]  # Replace with your internal CIDRs
#ensure no white spaces
allowed_cidrs   = ["0.0.0.0/0", "103.22.140.161/32"]  # Replace with your allowed CIDR
