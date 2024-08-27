# Backup and Import Script for MySQL

This script facilitates backing up specific tables from a MySQL database and importing them into a Google Cloud SQL instance. The backup is stored in a Google Cloud Storage (GCS) bucket, and then it is imported into a Cloud SQL instance.

## Prerequisites

- **Google Cloud SDK**: Ensure the `gcloud` command-line tool is available in your environment.
- **Service Account Key**: A Google Cloud service account key file with appropriate permissions (e.g., Cloud SQL Admin, Storage Admin).
- **MySQL**: Access to a MySQL server (local or remote) and credentials.
- **Google Cloud Storage Bucket**: A bucket in Google Cloud Storage for storing backups.

## Parameters

The script accepts the following parameters:

- `MYSQL_USER`: MySQL username used to connect to the MySQL server.
- `MYSQL_PASSWORD`: MySQL password for the user.
- `MYSQL_HOST`: Hostname or IP address of the MySQL server.
- `MYSQL_DATABASE`: Name of the MySQL database to back up.
- `GCS_BUCKET`: Google Cloud Storage bucket name where the backup will be uploaded.
- `CLOUDSQL_INSTANCE`: Name of the Cloud SQL instance to import the backup into.
- `CLOUDSQL_DATABASE`: Name of the Cloud SQL database to import the tables into.
- `TABLES` (Optional): Comma-separated list of table names to back up. If omitted, the entire database will be backed up.

## Usage

### Command Line Usage

```bash
./backup_and_import.sh <MYSQL_USER> <MYSQL_PASSWORD> <MYSQL_HOST> <MYSQL_DATABASE> <GCS_BUCKET> <CLOUDSQL_INSTANCE> <CLOUDSQL_DATABASE> [<TABLES>]
