---
title: "Backup Health Checks"
status: "standard"
---

## Systemd checks

```bash
systemctl list-timers --all --no-pager | rg -i 'git-mirror|backup|restic'
systemctl --failed --no-pager | rg -i 'git-mirror|backup|restic'
journalctl --since \"24 hours ago\" --no-pager | rg -i 'git-mirror|missing_mount|restic|backup'
```

## Mount checks (NAS)

```bash
mount | rg -i '/mnt/vault/projects'
```

## Restic checks

```bash
restic snapshots
restic check
```
