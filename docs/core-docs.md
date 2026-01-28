---
title: "Core Docs (Portable)"
status: "standard"
---

This is the minimal documentation set we standardize across repos so work stays navigable and recoverable.

## Required files (repo root)

- `AGENTS.md`: guardrails for coding agents + required reading order
- `README.md`: human overview + entrypoints
- `CHANGELOG.md`: high-level change log (Keep a Changelog format)

## Required files (`docs/`)

- `docs/index.md`: docs hub for the repo
- `docs/current-state.md`: “what exists and works right now”
- `docs/roadmap.md`: “what we plan to change next”

## Optional files (`docs/`)

- `docs/active-work.md`: current work only (1–3 items max; point to YAML tasks)

## SRD block markers (portable updates)

Portable updates apply **only** to SRD blocks inside the core docs set.

Marker format:

```
<!-- SRD:BEGIN -->
...portable content...
<!-- SRD:END -->
```

Rules:

- Portable repo is the source of truth for the SRD block.
- Local files keep everything **outside** the block.
- If a file is missing markers, block sync skips it (and logs).

## Core docs block-sync targets

These files should include SRD markers:

- `AGENTS.md`
- `README.md`
- `CHANGELOG.md`
- `docs/index.md`
- `docs/current-state.md`
- `docs/roadmap.md`
- `docs/active-work.md` (optional)
