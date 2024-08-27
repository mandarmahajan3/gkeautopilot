#!/bin/bash

# Parameters
MYSQL_USER=$1
MYSQL_PASSWORD=$2
MYSQL_HOST=$3
MYSQL_DATABASE=$4
GCS_BUCKET=$5
CLOUDSQL_INSTANCE=$6
CLOUDSQL_DATABASE=$7

# Validate parameters
if [[ -z "$MYSQL_USER" || -z "$MYSQL_PASSWORD" || -z "$MYSQL_HOST" || -z "$MYSQL_DATABASE" || -z "$GCS_BUCKET" || -z "$CLOUDSQL_INSTANCE" || -z "$CLOUDSQL_DATABASE" ]]; then
  echo "Usage: $0 <MYSQL_USER> <MYSQL_PASSWORD> <MYSQL_HOST> <MYSQL_DATABASE> <GCS_BUCKET> <CLOUDSQL_INSTANCE> <CLOUDSQL_DATABASE>"
  exit 1
fi

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SQL_FILE="${MYSQL_DATABASE}_${TIMESTAMP}.sql"

# Step 1: Create MySQL Dump and Upload to GCS
echo "Creating MySQL dump and uploading to GCS..."
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$MYSQL_HOST" --databases "$MYSQL_DATABASE" | gsutil cp - "gs://$GCS_BUCKET/$SQL_FILE"

if [ $? -ne 0 ]; then
  echo "Failed to create and upload MySQL dump."
  exit 1
fi
echo "MySQL dump successfully uploaded to gs://$GCS_BUCKET/$SQL_FILE"

# Step 2: Import SQL Dump into Cloud SQL
echo "Importing SQL dump into Cloud SQL..."
gcloud sql import sql "$CLOUDSQL_INSTANCE" "gs://$GCS_BUCKET/$SQL_FILE" --database="$CLOUDSQL_DATABASE"

if [ $? -ne 0 ]; then
  echo "Failed to import SQL dump into Cloud SQL."
  exit 1
fi
echo "SQL dump successfully imported into Cloud SQL instance $CLOUDSQL_INSTANCE."

echo "Backup and import process completed successfully."
