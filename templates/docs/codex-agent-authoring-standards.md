---
title: "Codex Agent Authoring Standards"
status: "standard"
---

## Purpose

Keep repo-level agent guidance consistent across projects.

## `AGENTS.md`

Use `AGENTS.md` to define:

- repo purpose
- required reading order
- guardrails (secrets, reports/, tests, etc.)

## Overrides (optional convention)

If you need local-only instructions, prefer one of:

- `~/.codex/AGENTS.md` (personal global guidance)
- a gitignored file like `AGENTS.local.md` (manual reference)

Keep committed `AGENTS.md` stable and team-friendly.

Reference: `https://developers.openai.com/codex/guides/agents-md`
