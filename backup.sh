#!/bin/bash

TARGET_BACKUP_LOCATION=/tmp/posthog

echo "Preparing backup..."
rm -rf ${TARGET_BACKUP_LOCATION}
mkdir ${TARGET_BACKUP_LOCATION}
mkdir ${TARGET_BACKUP_LOCATION}/sql
mkdir ${TARGET_BACKUP_LOCATION}/data

tables=$(clickhouse-client --query "SELECT name FROM system.tables WHERE database = 'posthog' AND engine LIKE '%MergeTree'")

echo "Staring backup..."
for table in ${tables}; do
    echo "Dumping table ${table}"
    mkdir ${TARGET_BACKUP_LOCATION}/data/${table}
    clickhouse-client --database "posthog" --query "ALTER TABLE ${table} FREEZE"
    clickhouse-client --database "posthog" --query="SHOW CREATE TABLE ${table}" --format="TabSeparatedRaw" | tee ${TARGET_BACKUP_LOCATION}/sql/${table}.sql
    cp -r /var/lib/clickhouse/shadow/ ${TARGET_BACKUP_LOCATION}/data/${table}
    rm -rf /var/lib/clickhouse/shadow/*
    echo "Table ${table} dumped"
done
