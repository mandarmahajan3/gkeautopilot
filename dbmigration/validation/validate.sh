#!/bin/bash

# Parameters
SOURCE_MYSQL_USER=$1
SOURCE_MYSQL_PASSWORD=$2
SOURCE_MYSQL_HOST=$3
SOURCE_MYSQL_DATABASE=$4

DEST_MYSQL_USER=$5
DEST_MYSQL_PASSWORD=$6
DEST_MYSQL_HOST=$7
DEST_MYSQL_DATABASE=$8

TABLES=$9  # Comma-separated list of tables to validate

# Validate parameters
if [[ -z "$SOURCE_MYSQL_USER" || -z "$SOURCE_MYSQL_PASSWORD" || -z "$SOURCE_MYSQL_HOST" || -z "$SOURCE_MYSQL_DATABASE" || -z "$DEST_MYSQL_USER" || -z "$DEST_MYSQL_PASSWORD" || -z "$DEST_MYSQL_HOST" || -z "$DEST_MYSQL_DATABASE" ]]; then
  echo "Usage: $0 <SOURCE_MYSQL_USER> <SOURCE_MYSQL_PASSWORD> <SOURCE_MYSQL_HOST> <SOURCE_MYSQL_DATABASE> <DEST_MYSQL_USER> <DEST_MYSQL_PASSWORD> <DEST_MYSQL_HOST> <DEST_MYSQL_DATABASE> [<TABLES>]"
  exit 1
fi

# Validate row counts
echo "Validating row counts..."

if [[ -z "$TABLES" ]]; then
  TABLES=$(mysql -u "$SOURCE_MYSQL_USER" -p"$SOURCE_MYSQL_PASSWORD" -h "$SOURCE_MYSQL_HOST" -D "$SOURCE_MYSQL_DATABASE" -e "SHOW TABLES;" -s -N)
fi

for TABLE in $(echo $TABLES | tr ',' ' '); do
  SRC_COUNT=$(mysql -u "$SOURCE_MYSQL_USER" -p"$SOURCE_MYSQL_PASSWORD" -h "$SOURCE_MYSQL_HOST" -D "$SOURCE_MYSQL_DATABASE" -e "SELECT COUNT(*) FROM $TABLE;" -s -N)
  DEST_COUNT=$(mysql -u "$DEST_MYSQL_USER" -p"$DEST_MYSQL_PASSWORD" -h "$DEST_MYSQL_HOST" -D "$DEST_MYSQL_DATABASE" -e "SELECT COUNT(*) FROM $TABLE;" -s -N)
  
  if [ "$SRC_COUNT" -ne "$DEST_COUNT" ]; then
    echo "Row count mismatch for table $TABLE: Source ($SRC_COUNT) vs Destination ($DEST_COUNT)"
  else
    echo "Row count matched for table $TABLE: $SRC_COUNT"
  fi

  # Validate data mismatch
  echo "Validating data for table $TABLE..."
  SRC_DATA=$(mysql -u "$SOURCE_MYSQL_USER" -p"$SOURCE_MYSQL_PASSWORD" -h "$SOURCE_MYSQL_HOST" -D "$SOURCE_MYSQL_DATABASE" -e "SELECT * FROM $TABLE ORDER BY 1 LIMIT 1000;" | sort)
  DEST_DATA=$(mysql -u "$DEST_MYSQL_USER" -p"$DEST_MYSQL_PASSWORD" -h "$DEST_MYSQL_HOST" -D "$DEST_MYSQL_DATABASE" -e "SELECT * FROM $TABLE ORDER BY 1 LIMIT 1000;" | sort)

  DIFF=$(diff <(echo "$SRC_DATA") <(echo "$DEST_DATA"))

  if [ -n "$DIFF" ]; then
    echo "Data mismatch detected in table $TABLE"
    echo "$DIFF"
  else
    echo "Data matched for table $TABLE"
  fi
done

echo "Data validation completed."
