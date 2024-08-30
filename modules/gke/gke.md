# Google Kubernetes Engine (GKE) Cluster Configuration

This document outlines the configuration for setting up a Google Kubernetes Engine (GKE) cluster using Terraform. The cluster is configured with Autopilot mode, private nodes, and specific network settings to ensure security and optimal performance.

## Terraform Configuration

### Providers

- **Google Provider**: Manages resources on Google Cloud Platform.
  - **`project`**: The Google Cloud project ID where resources will be created.
  - **`region`**: The region where the GKE cluster will be deployed.

- **Kubernetes Provider**: Interacts with the Kubernetes API once the cluster is created.
  - The provider version is specified as `~> 2.0` to ensure compatibility with the latest Kubernetes resources.

### Data Source

- **`google_client_config.default`**: Fetches the current Google Cloud client configuration, including the project and region.

## GKE Cluster

### Variables

- **`var.cluster_name`**: The name of the GKE cluster.
- **`var.region`**: The region where the cluster will be created.
- **`var.network`**: The VPC network where the cluster will be deployed.
- **`var.subnetwork`**: The subnetwork within the VPC for the cluster.
- **`var.authorized_network`**: The CIDR block that specifies the range of IP addresses allowed to access the cluster’s control plane.
- **`var.master_ipv4_cidr_block`**: The CIDR block for the master’s private IPv4 addresses.

### Settings

- **`enable_autopilot`**: Enabled to utilize Google’s Autopilot mode, which automatically manages resources, security, and scaling for the cluster.
- **`deletion_protection`**: Disabled, allowing the cluster to be deleted when no longer needed. Change this to enabled for production environments.
- **`network`**: Specifies the VPC network to which the cluster is connected.
- **`subnetwork`**: Defines the subnetwork within the VPC for the cluster.

### Master Authorized Networks

- **`cidr_block`**: Restricts access to the Kubernetes master (control plane) to a specific range of IP addresses, enhancing security.

### Release Channel

- **`channel`**: Set to `STABLE` to ensure the cluster receives stable and reliable updates.

### Vertical Pod Autoscaling

- **`enabled`**: Allows Kubernetes to automatically adjust the CPU and memory requests/limits for running pods based on real-time usage.

### Private Cluster Configuration

- **`enable_private_nodes`**: Ensures that all nodes in the cluster are created without public IP addresses, enhancing security.
- **`enable_private_endpoint`**: Disabled, meaning the Kubernetes master will still have a public endpoint, but nodes communicate with the master privately.
- **`master_ipv4_cidr_block`**: Defines the private IPv4 range for the Kubernetes master, ensuring that master traffic is isolated and secure.

## Summary

