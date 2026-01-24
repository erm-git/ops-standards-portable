---
title: "Core Docs (Portable SRD)"
status: "standard"
---

## Core Docs (required set)

Define the minimum “core docs” every project should have, with clear responsibilities so docs don’t drift into duplicates:

- `AGENTS.md` — agent onboarding + guardrails (repo root)
- `README.md` — repo entrypoint (repo root)
- `CHANGELOG.md` — notable changes (repo root)
- `docs/index.md` — docs landing page + table of contents (MkDocs home)
- `docs/current-state.md` — “as-is” truth (what exists and works now)
- `docs/roadmap.md` — “to-be” near-term plan (what’s next)
- `docs/active-work.md` — WIP anchor / single-flight (what you’re doing right now)

## One-line rule to stop drift

- If it’s **today’s truth** → `docs/current-state.md`
- If it’s **next work** → `docs/roadmap.md`
- If it’s **what you’re doing right now** → `docs/active-work.md`
- If it’s **how to write docs** → `srd/authoring-standards/`

## Update discipline (expected cadence)

- `docs/active-work.md`: update every session (start/end)
- `docs/roadmap.md`: update when priorities change or items complete
- `docs/current-state.md`: update when reality changes (new standard/behavior is now true)
- `CHANGELOG.md`: update when a change is notable
