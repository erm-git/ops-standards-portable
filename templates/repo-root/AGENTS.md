<!-- PORTABLE:BEGIN -->
## Portable Standards

This block is synced from `srd/agents-block.md`. Do not edit here.

- Portable standards: `docs/index.md`
- Portable SRD: `srd/index.md`
- Install path is host-specific (typical: `/opt/ops-standards/`).
<!-- PORTABLE:END -->

# Coding Agent Instructions — {{PROJECT_TITLE}}

## Repo Purpose

{{PROJECT_PURPOSE}}

## Required Reading Before Changes

1. `AGENTS.md` (this file)
2. `README.md`
3. `docs/current-state.md`
4. `docs/roadmap.md`
5. `docs/active-work.md` (if present)

## Guardrails

- Do not commit secrets (never plaintext).
- Treat `reports/` as local-only unless the repo explicitly says otherwise.
- Prefer small, scoped changes and commit frequently.
