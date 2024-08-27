# MySQL Backup and Import to Google Cloud SQL

This project automates the process of creating a MySQL database backup, uploading it to a Google Cloud Storage (GCS) bucket, and importing it into a Cloud SQL instance using a Jenkins CI/CD pipeline.

## Requirements

- MySQL installed locally
- Google Cloud SDK installed
- Jenkins with Docker support

## Usage

### 1. Parameterized Bash Script

The `backup_and_import.sh` script performs the following steps:
1. Creates a MySQL dump of the specified database.
2. Uploads the dump to a specified GCS bucket.
3. Imports the SQL dump into the specified Cloud SQL instance.

#### Example Command

```bash
./backup_and_import.sh <MYSQL_USER> <MYSQL_DATABASE> <GCS_BUCKET> <CLOUDSQL_INSTANCE> <CLOUDSQL_DATABASE>
