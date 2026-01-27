---
title: "Bring Repos Up to Standard (CGP SRD)"
status: "standard"
---

## Goal

Upgrade a repo to current standards without breaking existing conventions.

## Standardization protocol (agent‑friendly)

1) **Inventory** repo files against the core‑docs contract.  
2) **Add only missing docs** (never overwrite without approval).  
3) **Normalize format** of existing docs to current authoring standards (front matter, headings, bullets, code fences).  
4) **Add pointer docs** for system‑wide standards (do not copy unless customization is required).  
5) **Ensure standard Make targets** exist (or document why not).  
6) **Stop at `git review-ready`** for human approval.

## Core docs contract (presence check)

Required:

- `AGENTS.md`
- `README.md`
- `CHANGELOG.md`
- `docs/index.md`
- `docs/current-state.md`
- `docs/roadmap.md`
- `docs/active-work.md`

If any are missing, **add** from SRD templates (seed + customize where required).

## Format normalization (existing docs)

For existing docs, **do not rewrite content**, only normalize format:

- YAML front matter with `title:` and optional `status:`
- First in‑body heading is `##` (not `#`)
- Use `-` bullets
- Use fenced code blocks with language tags

Reference: `srd/docs/authoring-standards/markdown.md`

## Rules

1) **Do not delete or rename** existing paths unless the repo owner approves.  
2) **Do not change runtime paths** (`/opt`, `/srv`, `/var/opt`) without an explicit migration plan.  
3) **Prefer additive changes** (new docs, new scripts) over rewrites.  
4) **Preserve repo-specific behavior** (custom Make targets, scripts, CI) unless the owner requests change.  
5) **Keep changes reviewable** (small commits by category).

## Minimum alignment checklist (safe defaults)

- Core docs set present (`AGENTS.md`, `README.md`, `CHANGELOG.md`, `docs/index.md`, `docs/current-state.md`, `docs/roadmap.md`, `docs/active-work.md`).
- `AGENTS.md` points to SRD and does not conflict with SRD policy.
- `AGENTS.md` includes repo MCP policy (allowed MCPs + approvals) per `srd/docs/policies/mcp-standards.md`.
- Add pointer docs for system-wide standards (do not copy unless repo must customize).
  - `docs/backup-standards.md`
  - `docs/backup-health.md`
  - `docs/secrets-standards.md`
  - `docs/mcp-standards.md`
  - `docs/git-hygiene.md`
  - `docs/repo-standardization.md`
- Standard Make targets present (`fmt`, `lint`, `test`, `type`; docs targets where applicable).
- Ensure backups doc exists (`docs/backups.md`) with repo-specific paths + pointers to SRD.

## When to copy vs pointer

- **Pointer**: system-wide canonical docs that should not be customized.
- **Copy**: repo-specific runbooks, paths, services, or any doc the repo must own.
- **Seed + customize**: `AGENTS.md`, `docs/backups.md`, `docs/runbooks/*`.

## Migration pattern (safe)

1) Read existing docs + runbooks first.  
2) Add missing core docs (do not overwrite).  
3) Add pointer docs for SRD standards.  
4) Add repo-specific docs (backups/runbooks) only if missing.  
5) End in `git review-ready` for human approval.

## Optional: Copilot → Codex‑only migration

Only apply when the repo owner explicitly requests a Codex‑only workflow.

Steps:

1) Update `AGENTS.md` to state Codex‑only policy and required reading order.  
2) Remove `.github/copilot-instructions.md` (or replace with a pointer to `AGENTS.md`).  
3) Keep changes additive unless removal is explicitly approved.  

## Example: git-fork-sync + repo-docs (current gaps)

### git-fork-sync

Present:
- `AGENTS.md`, `README.md`, `CHANGELOG.md`
- `docs/index.md`, `docs/current-state.md`, `docs/roadmap.md`, `docs/active-work.md`

Missing (recommended pointer docs):
- `docs/backup-standards.md`
- `docs/backup-health.md`
- `docs/secrets-standards.md`
- `docs/mcp-standards.md`
- `docs/git-hygiene.md`
- `docs/repo-standardization.md`

### repo-docs

Present:
- `AGENTS.md`
- `docs/index.md` (published corpus index)

Missing (core docs + pointers):
- `README.md`, `CHANGELOG.md`
- `docs/current-state.md`, `docs/roadmap.md`, `docs/active-work.md`
- pointer docs listed above
