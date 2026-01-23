---
title: "FHS Quick Reference (CGP)"
status: "standard"
---

## System locations (cheat sheet)

- **`/opt/tools/`**: local MCP servers and shared tooling
- **`/usr/local/bin/`**: user-managed CLI entrypoints (preferred over `/usr/bin`)
- **`/usr/local/sbin/`**: system scripts run by services/timers
- **`/srv/dev/`**: active git worktrees
- **`/srv/`**: long-lived runtime data trees (non‑repo)
- **`/var/opt/`**: service state (databases, indexes, caches)
- **`~/.config/`**: user config + secrets loader

## Ownership policy (CCON)

- `/opt/*` is **erm-owned by default** (including vendor trees) so tools are usable without sudo.
- `/usr`, `/var`, `/etc` remain **root-owned** unless a service explicitly requires otherwise.
- If a service must run as root, keep its state under `/var` or `/var/opt` with root ownership.

## Standard install pattern

Keep scripts in their repo, then install a **thin launcher** into `/usr/local/bin`:

```bash
sudo ln -sf /opt/ops-standards/scripts/sync-agents-srd.sh /usr/local/bin/sync-agents-srd
```
