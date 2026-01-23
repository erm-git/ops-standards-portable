---
title: "Backup Health Checks (CGP SRD)"
status: "standard"
---

## Goal

Detect backup drift early (timers failing, mounts missing, repos stale).

## Systemd checks

List relevant timers and recent failures:

```bash
systemctl list-timers --all --no-pager | rg -i 'git-mirror|backup|restic'
systemctl --failed --no-pager | rg -i 'git-mirror|backup|restic'
```

Last 24h logs (pattern search):

```bash
journalctl --since \"24 hours ago\" --no-pager | rg -i 'git-mirror|missing_mount|restic|backup'
```

## Mount checks (NAS)

Verify mounts exist before jobs run:

```bash
mount | rg -i '/mnt/vault/projects'
```

## Restic checks

Confirm repositories are reachable and snapshots are recent (per repo):

```bash
restic snapshots
restic check
```

## Alert wiring (CGP convention)

Use systemd `OnFailure=` to notify on job failures.

Reference implementation notes: `srd/cgp/cgp-backup-standards.md`.
