---
title: "Codex (CGP SRD)"
status: "standard"
---

This page is the **portable ops-standards reference** for using Codex as a coding agent.

## Scope

- Codex CLI is the source of truth for agent config.
- Repo guardrails live in repo `AGENTS.md` (and nested `AGENTS.md` where needed).
- Secrets are never stored in Codex configs; only environment variables are consumed.

## What Codex Loads (Instruction Chain)

Codex can load extra instructions from `AGENTS.md` and merges them top-down:

- `~/.codex/AGENTS.md` (personal global guidance)
- `AGENTS.md` at repo root (shared project notes)
- `AGENTS.md` in the current working directory (sub-folder/feature specifics)

Disable loading of project docs with `--no-project-doc` or `CODEX_DISABLE_PROJECT_DOC=1`.

Reference: `https://developers.openai.com/codex/guides/agents-md`

## Codex Config

Codex state root:

- `CODEX_HOME` (default: `~/.codex`)

Key file:

- `$CODEX_HOME/config.toml`

Reference: `https://developers.openai.com/codex/config-reference`

### MCP server config

Codex can connect to MCP servers configured in `$CODEX_HOME/config.toml`.

Reference: `https://developers.openai.com/codex/config-reference`

## Skills

Skills are folders containing a required `SKILL.md` (plus optional `scripts/`, `references/`, `assets/`).

Install location:

- `$CODEX_HOME/skills/<skill-name>` (defaults to `~/.codex/skills`)

References:

- `https://developers.openai.com/codex/skills`
- `https://developers.openai.com/codex/skills/create-skill`

### Ops-standards skill packaging

Portable custom skills live in this repo under `codex/skills/`.

Install/update them into `$CODEX_HOME/skills` with:

```bash
cd /path/to/ops-standards
scripts/install-codex-skills.sh --apply
```

## MCP (Tools + KB)

Codex MCP registry:

- `$CODEX_HOME/config.toml` (`[mcp_servers.*]`)

Policy:

- Put tokens in `$HOME/.config/secrets/...` (SOPS encrypted)
- Export env vars via the secrets loader, then reference env vars in MCP config

Canonical doc: `srd/mcp-standards.md`
