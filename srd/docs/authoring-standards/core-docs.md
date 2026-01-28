---
title: "Core Docs (Portable SRD)"
status: "standard"
---

## Core Docs (required set)

Define the minimum “core docs” every CGP project should have, with clear responsibilities so docs don’t drift into duplicates:

- `AGENTS.md` — agent onboarding + guardrails (repo root)
- `README.md` — repo entrypoint (repo root)
- `CHANGELOG.md` — notable changes (repo root)
- `docs/index.md` — docs landing page + table of contents (MkDocs home)
- `docs/current-state.md` — “as-is” truth (what exists and works now)
- `docs/roadmap.md` — “to-be” near-term plan (what’s next)
- `docs/active-work.md` — WIP anchor / single-flight (what you’re doing right now)

## One-line rule to stop drift

- If it’s **today’s truth** → `docs/current-state.md`
- If it’s **future direction / milestones** → `docs/roadmap.md`
- If it’s **what you’re doing right now** → `docs/active-work.md`
- If it’s **how to write docs** → `srd/docs/authoring-standards/`

## Core docs semantics (do not drift)

These files have specific meanings. Do not repurpose them.

- `docs/roadmap.md`: future direction (near/medium/far goals + milestones). Not a task log/backlog.
- `docs/active-work.md`: what is being worked on now (keep 1-3 items max; point to YAML tasks when used).
- `docs/current-state.md`: what exists now (brief, factual pointers).
- `yaml-tasks/`: execution tracker (drafts/todo/in-progress/done). This is the backlog/queue when present.
- `CHANGELOG.md`: notable user/operator-facing changes (not every small internal edit).
- `docs/scratchpad.md` + `docs/scratchpad/` (optional): unstructured notes only (not canonical).

## SRD block markers (portable updates)

When portable updates need to flow into local core docs without clobbering host‑specific content, use SRD block markers:

```
<!-- SRD:BEGIN -->
...portable content...
<!-- SRD:END -->
```

Rules:

- Portable repo is the source of truth for the SRD block.
- Local files keep everything **outside** the block.
- If a file is missing markers, the updater skips it (and logs).

## Update discipline (expected cadence)

- `docs/active-work.md`: update every session (start/end)
- `docs/roadmap.md`: update when goals/milestones change
- `docs/current-state.md`: update when reality changes (new standard/behavior is now true)
- `CHANGELOG.md`: update when a change is notable
