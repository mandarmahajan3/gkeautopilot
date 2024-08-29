#ENTERPRISE_PLUS vs ENTERPRISE_PLUS
##HA
#replicas



resource "google_sql_user" "iam_group_user" {
  name     = "GCP_CIRRUS_HCC_POC@groups.optum.com"
  instance = google_sql_database_instance.main.name
  type     = "CLOUD_IAM_GROUP"
}

resource "google_sql_user" "iam_group_user" {
  name     = "iam_group@example.com"
  instance = google_sql_database_instance.main.name
  type     = "CLOUD_IAM_user"
}


resource "google_sql_user" "iam_group_user" {
  name     = "iam_group@example.com"
  instance = google_sql_database_instance.main.name
  type     = "CLOUD_IAM_user"
}

