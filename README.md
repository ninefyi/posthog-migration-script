# How to use it

## Backup

```BASH
kubectl cp backup.sh chi-posthog-posthog-0-0-0:/tmp/backup.sh -n anyday-posthog
```

```BASH
cd /tmp/ | chomod +x /tmp/backup.sh | bash backup.sh
```

## Restore

```BASH
kubectl cp chi-posthog-posthog-0-0-0:/tmp/posthog/sql posthog/sql -n anyday-posthog
```
