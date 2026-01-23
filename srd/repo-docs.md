---
title: "repo-docs + git-fork-sync (CGP)"
status: "standard"
---

This page documents a **host-local documentation ETL pipeline** so Codex agents can reliably retrieve external references without hitting the live web.

## Roles

- **Management plane:** `/srv/dev/git-fork-sync`
  - Pulls/updates sources
  - Normalizes docs into a stable MkDocs tree
  - Writes searchable indexes
- **Published output:** `/srv/dev/repo-docs`
  - Human-browsable MkDocs site content under `docs/`
  - Machine indexes under `_index/`

## Output Contract (What Other Repos Should Reference)

If a repo needs the corpus for agent retrieval, point at:

- `/srv/dev/repo-docs/_index/`

This avoids tying projects to the internal staging/log layout of `git-fork-sync`.

## How Sync Works (High Level)

From `git-fork-sync`:

- Keeps clones under `/srv/dev/<repo>` synced (ff-only by default)
- Exports docs-only trees into `/srv/dev/repo-docs/docs/<repo>/`
- Tracks managed files via `.managed-files.txt` so local additions are preserved
- Writes per-repo indexes into `/srv/dev/repo-docs/_index/<repo>/docs.jsonl`

Canonical references:

- `/srv/dev/git-fork-sync/docs/sync-doc-forks.md`
- `/srv/dev/git-fork-sync/docs/repo-docs-layout.md`
- `/srv/dev/git-fork-sync/docs/repo-docs/index.md`

## Scheduling (systemd)

`git-fork-sync` ships systemd units:

- `/srv/dev/git-fork-sync/systemd/sync-doc-forks.service`
- `/srv/dev/git-fork-sync/systemd/sync-doc-forks.timer`

Standard: keep the timer on the host and monitor outcomes via `journalctl` (prefer journald over ad-hoc log files).

## Guidance: Using This with MCP

Prefer these patterns:

- Use `repo_docs` MCP for “search across many synced repos” retrieval.
- Use `ops_standards_srd` MCP for “host-wide standards in ops-standards” retrieval.
- Use `openaiDeveloperDocs` MCP when you need the latest OpenAI docs (repo-docs mirror may lag its sync interval).

## Read-only Improvement Notes (Current Pipeline)

Low-risk improvements that generally help reliability:

- Ensure sync jobs are journald-visible (unit logs, not only file logs).
- Treat source lists as canonical (`sources.yaml`) and generate derived maps (`fork-docs.map`), to avoid drift.
- Keep “published output” (`/srv/dev/repo-docs`) free of staging/tmp state and secrets.
- Keep per-project rules in a single place (`repo-rules.toml`) so normalization remains deterministic and reviewable.
