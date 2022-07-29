#!/bin/bash

SOURCE_BACKUP_LOCATION=chi-posthog-posthog-0-0-0:/tmp/posthog
TARGET_BACKUP_LOCATION=posthog

echo "Preparing copy from pods to local..."

mkdir -p posthog/data
mkdir -p posthog/sql

echo "Copying folder sql from local to pod..."
kubectl cp ${SOURCE_BACKUP_LOCATION}/sql/ ${TARGET_BACKUP_LOCATION}/sql/ -n [namespace]

tables=$(ls -1 posthog/sql | sed -e 's/\..*$//')

for table in ${tables}; do
    echo "Copying table ${table} from pod to local..."
    kubectl cp ${SOURCE_BACKUP_LOCATION}/data/${table} ${TARGET_BACKUP_LOCATION}/data/${table} -n [namespace]
    echo "Table ${table} copied"
done