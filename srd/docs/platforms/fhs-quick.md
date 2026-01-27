---
title: "FHS Quick Reference (CGP)"
status: "standard"
---

## System locations (cheat sheet)

- **`/opt/<project>/`**: installed project runtimes (including MCP servers)
- **`/usr/local/bin/`**: user-managed CLI entrypoints (preferred over `/usr/bin`)
- **`/usr/local/sbin/`**: system scripts run by services/timers
- **`/srv/dev/`**: active git worktrees
- **`/srv/`**: long-lived runtime data trees (non‑repo)
- **`/var/opt/`**: service state (databases, indexes, caches)
- **`~/.config/`**: user config + secrets loader

## Ownership policy (CCON)

- Root-level directories (e.g., `/opt`, `/srv`, `/var`) remain `root:root`.
- New project directories under `/opt/<project>` are created with `sudo` and then chowned to the primary user.
- Do not change ownership of `/opt` itself.
- `/usr`, `/var`, `/etc` remain **root-owned** unless a service explicitly requires otherwise.
- If a service must run as root, keep its state under `/var` or `/var/opt` with root ownership.

### Standard commands (example)

```bash
sudo mkdir -p /opt/<project>
sudo chown -R <user>:<group> /opt/<project>
```

## Standard install pattern

Keep scripts in their repo, then install a **thin launcher** into `/usr/local/bin`:

```bash
sudo ln -sf /opt/ops-standards/scripts/sync-agents-srd.sh /usr/local/bin/sync-agents-srd
```
