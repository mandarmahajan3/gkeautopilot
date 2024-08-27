#!/bin/bash

# Parameters
SOURCE_MYSQL_USER="root"
SOURCE_MYSQL_PASSWORD="password"
SOURCE_MYSQL_HOST="localhost"
SOURCE_MYSQL_DATABASE="classicmodels"

DEST_MYSQL_USER="root"
DEST_MYSQL_PASSWORD="password"
DEST_CLOUDSQL_INSTANCE="mysql-cirrus"
DEST_MYSQL_DATABASE="classicmodels"

TABLES="customers"  # Table to validate

# Validate parameters
if [[ -z "$SOURCE_MYSQL_USER" || -z "$SOURCE_MYSQL_PASSWORD" || -z "$SOURCE_MYSQL_HOST" || -z "$SOURCE_MYSQL_DATABASE" || -z "$DEST_MYSQL_USER" || -z "$DEST_MYSQL_PASSWORD" || -z "$DEST_CLOUDSQL_INSTANCE" || -z "$DEST_MYSQL_DATABASE" ]]; then
  echo "Usage: $0 <SOURCE_MYSQL_USER> <SOURCE_MYSQL_PASSWORD> <SOURCE_MYSQL_HOST> <SOURCE_MYSQL_DATABASE> <DEST_MYSQL_USER> <DEST_MYSQL_PASSWORD> <DEST_CLOUDSQL_INSTANCE> <DEST_MYSQL_DATABASE> [<TABLES>]"
  exit 1
fi

# Path to cloud_sql_proxy
CLOUD_SQL_PROXY_PATH="/path/to/cloud_sql_proxy"

# Validate row counts
echo "Validating row counts..."

for TABLE in $(echo $TABLES | tr ',' ' '); do
  SRC_COUNT=$(mysql -u "$SOURCE_MYSQL_USER" -p"$SOURCE_MYSQL_PASSWORD" -h "$SOURCE_MYSQL_HOST" -D "$SOURCE_MYSQL_DATABASE" -e "SELECT COUNT(*) FROM $TABLE;" -s -N)

  # Start cloud_sql_proxy in the background
  $CLOUD_SQL_PROXY_PATH -instances="$DEST_CLOUDSQL_INSTANCE"=tcp:3306 &

  # Wait for the proxy to start
  sleep 10

  DEST_COUNT=$(mysql -u "$DEST_MYSQL_USER" -p"$DEST_MYSQL_PASSWORD" -h "127.0.0.1" -D "$DEST_MYSQL_DATABASE" -e "SELECT COUNT(*) FROM $TABLE;" -s -N)

  # Stop cloud_sql_proxy
  killall cloud_sql_proxy

  if [ "$SRC_COUNT" -ne "$DEST_COUNT" ]; then
    echo "Row count mismatch for table $TABLE: Source ($SRC_COUNT) vs Destination ($DEST_COUNT)"
  else
    echo "Row count matched for table $TABLE: $SRC_COUNT"
  fi

  # Validate data mismatch
  echo "Validating data for table $TABLE..."
  SRC_DATA=$(mysql -u "$SOURCE_MYSQL_USER" -p"$SOURCE_MYSQL_PASSWORD" -h "$SOURCE_MYSQL_HOST" -D "$SOURCE_MYSQL_DATABASE" -e "SELECT * FROM $TABLE ORDER BY 1 LIMIT 1000;" | sort)

  # Start cloud_sql_proxy in the background
  $CLOUD_SQL_PROXY_PATH -instances="$DEST_CLOUDSQL_INSTANCE"=tcp:3306 &

  # Wait for the proxy to start
  sleep 10

  DEST_DATA=$(mysql -u "$DEST_MYSQL_USER" -p"$DEST_MYSQL_PASSWORD" -h "127.0.0.1" -D "$DEST_MYSQL_DATABASE" -e "SELECT * FROM $TABLE ORDER BY 1 LIMIT 1000;" | sort)

  # Stop cloud_sql_proxy
  killall cloud_sql_proxy

  DIFF=$(diff <(echo "$SRC_DATA") <(echo "$DEST_DATA"))

  if [ -n "$DIFF" ]; then
    echo "Data mismatch detected in table $TABLE"
    echo "$DIFF"
  else
    echo "Data matched for table $TABLE"
  fi
done

echo "Data validation completed."
