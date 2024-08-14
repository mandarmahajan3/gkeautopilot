output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "kubeconfig" {
  value = coalesce(<<EOT
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)}
    server: https://${google_container_cluster.primary.endpoint}
  name: ${google_container_cluster.primary.name}
contexts:
- context:
    cluster: ${google_container_cluster.primary.name}
    user: ${google_container_cluster.primary.name}
  name: ${google_container_cluster.primary.name}
current-context: ${google_container_cluster.primary.name}
users:
- name: ${google_container_cluster.primary.name}
  user:
    token: ${data.google_client_config.default.access_token}
EOT, "Cluster not created yet")
}


output "cluster_location" {
  value = google_container_cluster.primary.location
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "access_token" {
  value = data.google_client_config.default.access_token
}
