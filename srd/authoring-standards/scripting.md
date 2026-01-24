---
title: "Scripting Standards (Portable SRD)"
status: "standard"
---

## Scope

Guidelines for shell and Python scripts used across repos.

## Location

- Repo-local scripts live under `scripts/`.
- System entrypoints are thin launchers in `/usr/local/bin` (user) or `/usr/local/sbin` (services).
- Do not install full repos under `/usr/local/*`.

## Shell scripts (baseline)

- Use strict mode: `set -euo pipefail`.
- Require explicit args; support `--help`.
- Support `--dry-run` and `--apply` for destructive actions.
- Log to stderr; keep stdout for actual output.
- Avoid interactive prompts unless explicitly required.
- Use `rg` for searches when available.

## Python scripts (baseline)

- Prefer `python -m <module>` entrypoints for project CLIs.
- Use `pyproject.toml` for dependencies (uv-managed).
- Avoid `sys.path` hacks; use proper packaging.
- Keep scripts deterministic and non-interactive by default.

## Standard flags (CCON)

- `--help` for usage.
- `--dry-run` for previews (default when possible).
- `--apply` or `--write` for changes.
- `--force` for overwrites (explicit).

## Logging (services)

- Prefer journald (stdout/stderr) for service/timer output.
- Avoid file-only logs unless required.

## Secrets

- Never embed secrets in scripts.
- Read secrets from env vars loaded by the host secrets loader.
