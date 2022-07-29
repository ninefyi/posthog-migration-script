#!/bin/bash

SOURCE_BACKUP_LOCATION=chi-posthog-posthog-0-0-0:/tmp/posthog/data
TARGET_BACKUP_LOCATION=posthog/data

echo "Preparing copy from pods to local..."

mkdir -p posthog/data

tables=$(clickhouse-client --query "SELECT name FROM system.tables WHERE database = 'posthog' AND engine LIKE '%MergeTree'")

for table in ${tables}; do
    echo "Copying table ${table} from pod to local..."
    kubectl cp ${SOURCE_BACKUP_LOCATION}/${table} ${TARGET_BACKUP_LOCATION}/${table} -n [namespace]
    echo "Table ${table} copied"
done
