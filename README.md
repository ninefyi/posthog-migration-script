# How to use it

1. ```kubectl cp backup.sh chi-posthog-posthog-0-0-0:/tmp/backup.sh -n [namespace]```
2. ```bash backup.sh```
3. ```bash pod2local.sh```
4. ```bash local2pod.sh```
5. ```kubectl cp restore.sh chi-posthog-posthog-0-0-0:/tmp/restore.sh -n [namespace]```
6. ```bash restore.sh```
