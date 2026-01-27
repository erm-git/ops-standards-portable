<!-- SRD:BEGIN -->
## System Standards (SRD)

This block is synced from `srd/docs/policies/agents-block.md`. Do not edit here.

- Canonical standards: `srd/docs/`
- MCP policy: `srd/docs/policies/mcp-standards.md`
- MCP query playbook: `srd/docs/tools/mcp-query-playbook.md`
- Firecrawl is paid — do not use unless explicitly requested.
- If `MCP_REQUIRE_CONFIRM=1`, pass `confirm=true` for write/exec tools.
<!-- SRD:END -->

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
