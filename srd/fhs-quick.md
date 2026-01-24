---
title: "FHS Quick Reference (Portable)"
status: "standard"
---

## System locations (cheat sheet)

- **`/opt/<project>/`**: runtime wrappers/entrypoints for a project
- **`/usr/local/bin/`**: user-run CLI entrypoints (symlink targets)
- **`/usr/local/sbin/`**: service/timer entrypoints (symlink targets)
- **`/srv/dev/`**: active git worktrees
- **`/srv/git/`**: bare git mirrors
- **`/srv/<project>/`**: long-lived runtime data (non-repo)
- **`/var/opt/<project>/`**: service state (DBs, indexes, caches)
- **`~/.config/`**: user config + secrets loader

## Ownership policy (CCON)

- `/opt/*` is **primary-user owned by default** so tools are usable without sudo.
- `/srv/*` is **primary-user owned by default** for project data/mirrors.
- `/usr`, `/var`, `/etc` remain **root-owned** unless a service explicitly requires otherwise.
- If a service must run as root, keep its state under `/var` or `/var/opt` with root ownership.

## Standard install pattern

Keep scripts in their repo, then install a **thin launcher** into `/usr/local/bin`:

```bash
sudo ln -sf /opt/ops-standards/scripts/sync-agents-portable.sh /usr/local/bin/sync-agents-portable
```

Example (read-only UFW status helper):

```bash
sudo ln -sf /opt/ops-standards/scripts/ufw-status.sh /usr/local/bin/ufw-status
```

Prefer `/usr/local/sbin` for service/timer entrypoints:

```bash
sudo ln -sf /opt/<project>/scripts/<service>.sh /usr/local/sbin/<service>
```
