---
title: "Portable Standards"
status: "standard"
---

This directory contains **portable, host-agnostic** standards intended to be reused across:

- multiple hosts (Debian, Ubuntu, WSL, etc.)
- multiple repos/projects
- human + LLM collaboration

Non-goals:

- appliance-specific runbooks (TrueNAS UI/API, Proxmox, etc.)
- storage vendor details (B2, S3, rclone, restic)
- host inventory (IPs, mount points, dataset names)

Canonical portable source lives at the repo root.
Start with `README.md` for the quick start.

CGP-specific standards live in the private ops-standards repo.

## Start here

- `docs/core-docs.md`
- `docs/fhs.md`
- `docs/bootstrap.md`
- `docs/codex.md`
- `docs/wsl-seed.md`

## Offline standards copy

This portable bundle includes an offline copy of host-agnostic standards under:

- `srd/`

## Bootstrap

- Script: `scripts/bootstrap.sh`
- Codex skill: `portable-ops-bootstrap` (install via `scripts/install-codex-skill.sh --apply`)
