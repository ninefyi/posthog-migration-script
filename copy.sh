#!/bin/bash

SOURCE_BACKUP_LOCATION=chi-posthog-posthog-0-0-0:/tmp/posthog/data
TARGET_BACKUP_LOCATION=posthog/data

echo "Preparing copy..."
mkdir -p posthog/data

tables=$(ls -1 posthog/sql | sed -e 's/\..*$//')

for table in ${tables}; do
    echo "Copying table ${table}"
    kubectl cp ${SOURCE_BACKUP_LOCATION}/${table} ${TARGET_BACKUP_LOCATION}/${table} -n [namespace]
    echo "Table ${table} copied"
done