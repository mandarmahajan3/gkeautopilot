POST https://container.googleapis.com/v1/projects/uhg-poc-new/locations/us-central1/clusters
{
  "cluster": {
    "name": "autopilot-cluster-1",
    "network": "projects/uhg-poc-new/global/networks/default",
    "subnetwork": "projects/uhg-poc-new/regions/us-central1/subnetworks/default",
    "networkPolicy": {},
    "ipAllocationPolicy": {
      "useIpAliases": true,
      "clusterIpv4CidrBlock": "/17",
      "stackType": "IPV4"
    },
    "masterAuthorizedNetworksConfig": {
      "enabled": true,
      "cidrBlocks": [
        {
          "displayName": "allowkubectl",
          "cidrBlock": "0.0.0.0/0"
        }
      ],
      "gcpPublicCidrsAccessEnabled": true
    },
    "binaryAuthorization": {
      "evaluationMode": "DISABLED"
    },
    "autoscaling": {
      "enableNodeAutoprovisioning": true,
      "autoprovisioningNodePoolDefaults": {}
    },
    "networkConfig": {
      "enableIntraNodeVisibility": true,
      "datapathProvider": "ADVANCED_DATAPATH",
      "dnsConfig": {
        "clusterDns": "CLOUD_DNS",
        "clusterDnsScope": "CLUSTER_SCOPE"
      },
      "enableFqdnNetworkPolicy": false
    },
    "authenticatorGroupsConfig": {},
    "databaseEncryption": {
      "state": "DECRYPTED"
    },
    "verticalPodAutoscaling": {
      "enabled": true
    },
    "releaseChannel": {
      "channel": "REGULAR"
    },
    "notificationConfig": {
      "pubsub": {}
    },
    "initialClusterVersion": "1.29.6-gke.1254000",
    "location": "us-central1",
    "autopilot": {
      "enabled": true
    },
    "loggingConfig": {
      "componentConfig": {
        "enableComponents": [
          "SYSTEM_COMPONENTS",
          "WORKLOADS"
        ]
      }
    },
    "monitoringConfig": {
      "componentConfig": {
        "enableComponents": [
          "SYSTEM_COMPONENTS",
          "STORAGE",
          "POD",
          "DEPLOYMENT",
          "STATEFULSET",
          "DAEMONSET",
          "HPA",
          "CADVISOR",
          "KUBELET"
        ]
      },
      "managedPrometheusConfig": {
        "enabled": true
      }
    },
    "securityPostureConfig": {
      "mode": "BASIC",
      "vulnerabilityMode": "VULNERABILITY_BASIC"
    },
    "secretManagerConfig": {
      "enabled": false
    }
  }
}



CMDLINE 

gcloud beta container --project "uhg-poc-new" clusters create-auto "autopilot-cluster-1" --region "us-central1" --release-channel "regular" --enable-master-authorized-networks --master-authorized-networks 0.0.0.0/0 --network "projects/uhg-poc-new/global/networks/default" --subnetwork "projects/uhg-poc-new/regions/us-central1/subnetworks/default" --cluster-ipv4-cidr "/17" --binauthz-evaluation-mode=DISABLED


provider "kubernetes" {
  config_path            = "~/.kube/config"
  config_context_cluster = var.k8s_cluster_name
}

# Retrieve the database password from Google Secret Manager
data "google_secret_manager_secret_version" "db_password" {
  provider = google
  secret   = var.db_password_secret_id
  version  = "latest"
}

# Decode the base64-encoded secret data
locals {
  db_password = base64decode(data.google_secret_manager_secret_version.db_password.secret_data)
}



# Store the database password in a Kubernetes Secret in each namespace
resource "kubernetes_secret" "db_secret" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "db-secret"
    namespace = each.value
  }

  data = {
    db_password = base64encode(local.db_password)
  }
}






