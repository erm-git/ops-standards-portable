---
title: "Ops Standards Guide (CGP SRD)"
status: "standard"
---

This guide defines the **portable** conventions used across hosts and repos.
Host-specific implementation notes belong under `srd/docs/<host>/` (CGP uses `srd/docs/cgp/`).

## Purpose

- Keep shared standards/runbooks here so other repos can link back (no duplication).
- Make recovery and maintenance predictable across projects.
- Keep docs usable by both humans and Codex-style agents.

## Filesystem conventions (FHS-aligned)

Use consistent roles for paths (adapt if your distro/policies differ):

- `/opt/<project>`: optional, user-managed application/runtime code
- `/var/opt/<project>`: runtime data/state for the project
- `/srv/git/<project>.git`: local bare git repos (authoritative local push targets)
- `/srv/dev/<project>`: dev working trees (if you separate from `/opt`)
- `/srv/docker/<project>`: docker compose/config
- `/srv/www/<project>`: web roots/static artifacts (if applicable)

Prefer **one canonical path** per role and use bind mounts if you have legacy paths.

## Git vs backups (what goes where)

Track in Git (source of truth):

- application code and scripts
- configs (systemd units, reverse proxy config, compose files)
- docs/runbooks/YAML tasks
- non-secret metadata needed for recovery

Do not track in Git (backup instead):

- runtime data/state (`/var/opt/<project>`)
- logs/reports/caches
- indexes/venvs/build artifacts (usually rebuildable)
- secrets (use encryption)

## Secrets (portable pattern)

- Store secrets encrypted at rest (recommended: `sops` + `age`).
- Use a single, predictable root (recommended): `$HOME/.config/secrets/`.
- Keep decryption and env-export in one place (a single loader script) to avoid token sprawl.

See `srd/docs/policies/secrets-standards.md`.

## Backups (portable model)

The least disruptive, small-NAS-friendly model:

- offsite integrity: **dev host → restic → B2**
- local resiliency: **dev host → NAS git-mirror/ + NAS backup/**, plus **NAS ZFS snapshots**

See `srd/docs/policies/backup-standards.md`.

## Documentation structure (portable)

- Canonical standards: `srd/docs/`
- Host-specific inventories/runbooks: `srd/docs/<host>/` (CGP uses `srd/docs/cgp/`)
- WIP scratchpad (not required reading): `docs/active-work.md`

## Update discipline

When you change a system-wide standard, update ops-standards first so future work has a single source of truth.
