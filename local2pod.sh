#!/bin/bash

TARGET_BACKUP_LOCATION=chi-posthog-posthog-0-0-0:/tmp/posthog
SOURCE_BACKUP_LOCATION=posthog

# Access to destination posthog pod:
# mkdir /tmp/posthog
# mkdir /tmp/posthog/data
# mkdir /tmp/posthog/sql

echo "Preparing copy from local to pod..."

tables=$(ls -1 posthog/sql | sed -e 's/\..*$//')

echo "Copying folder sql from local to pod..."
kubectl cp ${SOURCE_BACKUP_LOCATION}/sql/ ${TARGET_BACKUP_LOCATION}/sql/ -n [namespace]

for table in ${tables}; do
    echo "Copying table ${table} from local to pod..."
    kubectl cp ${SOURCE_BACKUP_LOCATION}/data/${table} ${TARGET_BACKUP_LOCATION}/data/${table} -n [namespace]
    echo "Table ${table} copied"
done