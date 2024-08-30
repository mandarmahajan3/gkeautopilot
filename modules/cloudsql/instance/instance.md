# Cloud SQL Instance with High Availability and Private Service Connect

This document outlines the configuration for a Google Cloud SQL instance and its read replica, utilizing High Availability (HA) and Private Service Connect (PSC) features. The setup uses the Enterprise Plus edition and includes detailed settings for both the primary instance and the read replica.

## Cloud SQL Instance

### Variables
- **`var.instance_name`**: Name of the Cloud SQL instance.
- **`var.region`**: Region where the instance will be deployed.
- **`var.db_version`**: Version of the database engine.
- **`var.project_id`**: Google Cloud project ID where the instance will be created.
- **`var.db_tier`**: Machine type for the instance.
- **`var.allowed_consumer_projects`**: List of projects allowed to connect via Private Service Connect.

### Settings
- **`tier`**: Specifies the machine type for the instance (defined by `var.db_tier`).
- **`edition`**: Set to `ENTERPRISE_PLUS` for advanced features.
- **`availability_type`**: Set to `REGIONAL` to enable High Availability.
- **`data_cache_config.data_cache_enabled`**: Enables data caching to improve performance.
- **`ip_configuration.ssl_mode`**: Set to `ENCRYPTED_ONLY` to enforce SSL encryption.
- **`ip_configuration.ipv4_enabled`**: Disabled to restrict access to private networks.
- **`ip_configuration.psc_config.psc_enabled`**: Enabled for Private Service Connect.
- **`ip_configuration.psc_config.allowed_consumer_projects`**: Specifies allowed consumer projects for PSC.

### Database Flags
- **`lower_case_table_names`**: `1` (Makes table names case-insensitive).
- **`sql_mode`**: `NO_ENGINE_SUBSTITUTION` (Prevents automatic engine substitution).
- **`character_set_server`**: `latin1` (Configures character set for the database server).
- **`explicit_defaults_for_timestamp`**: `off` (Controls default timestamp values).
- **`cloudsql_iam_authentication`**: `on` (Enables IAM authentication for the instance).

## Read Replica

### Variables
- **`var.instance_name`**: Name of the primary Cloud SQL instance.
- **`var.region`**: Region for the read replica (same as primary instance).
- **`var.db_version`**: Version of the database engine (same as primary instance).
- **`var.project_id`**: Google Cloud project ID where the read replica will be created.

### Settings
- **`name`**: Derived from the primary instance name with `-replica` suffix.
- **`region`**: Same as the primary instance (`var.region`).
- **`project`**: Google Cloud project ID (`var.project_id`).
- **`database_version`**: Same as the primary instance (`var.db_version`).
- **`master_instance_name`**: References the primary instance to ensure synchronization.
- **`availability_type`**: Set to `REGIONAL` to ensure High Availability.
- **`ip_configuration.ipv4_enabled`**: Disabled to restrict access to private networks.

## Summary

This setup provides a robust Cloud SQL configuration with High Availability and Private Service Connect. The primary instance benefits from advanced features and enhanced security with PSC, while the read replica ensures data redundancy and load balancing.

For further customization and details, refer to the [Terraform documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance).
