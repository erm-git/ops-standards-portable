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

- `docs/active-work.md`: WIP scratchpad for the current session/run of sessions (not required reading)

## How to use `current-state.md` vs `active-work.md`

- `docs/current-state.md`: stable, canonical, updated when behavior/workflows change.
- `docs/active-work.md`: temporary scratchpad (strike through done items; wipe when complete).
