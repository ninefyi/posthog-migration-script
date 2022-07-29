#!/bin/bash

SOURCE_BACKUP_LOCATION=/tmp/posthog

echo "Staring restore..."

tables=$(clickhouse-client --query "SELECT name FROM system.tables WHERE database = 'posthog' AND engine LIKE '%MergeTree'")

for table in ${tables}; do
    if [ -d "${SOURCE_BACKUP_LOCATION}/data/${table}/shadow/1" ] 
    then
        directory="${SOURCE_BACKUP_LOCATION}/data/${table}/shadow/1/data/posthog/${table}/"

        echo "Coping.. ${directory}* /var/lib/clickhouse/data/posthog/${table}/detached/"       
        cp -r ${directory}* /var/lib/clickhouse/data/posthog/${table}/detached/
        
        echo "Restoring ${table} from ${directory}"
        parts=`ls -1 ${directory}`
        for part in ${parts}; do
            echo "ALTER TABLE ${table} ATTACH PART '${part}'"
            clickhouse-client --database posthog --query "ALTER TABLE ${table} ATTACH PART '${part}'"
        done
    
        clickhouse-client --database posthog --query "SELECT COUNT(1) from ${table}"
        echo "Table ${table} restored"
       
    fi
done
