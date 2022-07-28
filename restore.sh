#!/bin/bash

SOURCE_BACKUP_LOCATION=/tmp/posthog

echo "Preparing restore..."
rm -rf ${SOURCE_BACKUP_LOCATION}
mkdir ${SOURCE_BACKUP_LOCATION}
mkdir ${SOURCE_BACKUP_LOCATION}/sql
mkdir ${SOURCE_BACKUP_LOCATION}/data

tables=$(clickhouse-client --query "SELECT name FROM system.tables WHERE database = 'posthog' AND engine LIKE '%MergeTree'")

echo "Staring restore..."
for table in ${tables}; do
    echo "Restoring table ${table}"
    cp -r ${SOURCE_BACKUP_LOCATION}/data/posthog/{$table}/* /var/lib/clickhouse/data/posthog/${table}/detached/
    clickhouse-client --database posthog --query "ALTER TABLE ${table} ATTACH PARTITION 20220630"
    clickhouse-client --database posthog --query "SELECT COUNT(1) from ${table}"
    echo "Table ${table} restored"
done
