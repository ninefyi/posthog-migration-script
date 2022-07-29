#!/bin/bash

SOURCE_BACKUP_LOCATION=chi-posthog-posthog-0-0-0:/tmp/posthog
TARGET_BACKUP_LOCATION=posthog

echo "Preparing copy from pods to local..."

mkdir -p posthog/data
mkdir -p posthog/sql

echo "Copying folder sql from local to pod..."
kubectl cp ${SOURCE_BACKUP_LOCATION}/sql/ ${TARGET_BACKUP_LOCATION}/sql/ -n anyday-posthog

tables=$(clickhouse-client --query "SELECT name FROM system.tables WHERE database = 'posthog' AND engine LIKE '%MergeTree'")

for table in ${tables}; do
    echo "Copying table ${table} from pod to local..."
    kubectl cp ${SOURCE_BACKUP_LOCATION}/data/${table} ${TARGET_BACKUP_LOCATION}/data/${table} -n anyday-posthog
    echo "Table ${table} copied"
done