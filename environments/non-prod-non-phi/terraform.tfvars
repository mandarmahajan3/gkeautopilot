# GCP Project and Region
project_id = "your-prod-project-id"
region     = "us-central1"

# GKE Cluster
cluster_name           = "prod-gke-cluster"
network                = "your-vpc-network"
subnetwork             = "your-vpc-subnetwork"
authorized_network     = "your-authorized-network-cidr"
master_ipv4_cidr_block = "10.0.0.0/28"  # Adjust this as necessary

# Kubernetes Namespaces and Ingress Configuration
namespaces           = ["namespace1", "namespace2"]  # Replace with your namespaces
ingress_service_name = "your-ingress-service-name"  # Replace with your service name
ingress_service_port = 80  # Replace with your service port

# Network Policies
internal_cidrs = ["10.0.0.0/24", "10.1.0.0/24"]  # Replace with your internal CIDRs
allowed_cidr   = "192.168.1.0/24"  # Replace with your allowed CIDR
