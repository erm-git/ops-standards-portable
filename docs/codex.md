---
title: "Codex (Portable Basics)"
status: "standard"
---

This doc captures the **portable** pieces of “how to work with Codex agents” that apply across hosts.

## Project instructions: `AGENTS.md`

Codex can load extra instructions from `AGENTS.md` and merges them top-down:

1. `~/.codex/AGENTS.md` (personal global guidance)
2. `AGENTS.md` at repo root (shared project notes)
3. `AGENTS.md` in the current working directory (sub-folder/feature specifics)

Disable loading of project docs with `--no-project-doc` or `CODEX_DISABLE_PROJECT_DOC=1`.

Reference: `https://developers.openai.com/codex/guides/agents-md`

## Configuration

Codex state root:

- `CODEX_HOME` (default: `~/.codex`)

Key file:

- `$CODEX_HOME/config.toml`

## Skills

Skills are folders containing a required `SKILL.md` (plus optional `scripts/`, `references/`, `assets/`).

Install location:

- `$CODEX_HOME/skills/<skill-name>` (defaults to `~/.codex/skills`)

Reference: `https://developers.openai.com/codex/skills`

Portable skill install (recommended):

```bash
scripts/install-codex-skill.sh --apply
```

Installs (global skills bundled here):

- `codex-new-project`
- `codex-new-session`

## Safety posture

- Prefer repo-local, explicit guardrails (`AGENTS.md`) over ad-hoc prompting.
- Keep secrets out of docs and configs; inject via environment variables when needed.
