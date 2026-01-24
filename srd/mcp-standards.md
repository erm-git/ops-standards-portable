# MCP Standards (Portable SRD)

Goal: ensure Codex (CLI and IDE clients) can reliably use MCP servers with a consistent secrets workflow.

## Source of truth

- Codex CLI MCP registry (recommended source of truth): `~/.codex/config.toml`

Some environments also have an IDE-side MCP registry (for example VS Code Remote). If your IDE requires its own registry, treat `~/.codex/config.toml` as the source and sync it to the IDE registry.

## MCP server placement (CCON)

- Keep MCP server code in its repo (under `/srv/dev/<project>`).
- Install stable entrypoints under `/opt/<project>` and symlink into `/usr/local/bin` (user tools) or `/usr/local/sbin` (services).
- Do not store secrets in MCP configs; use env loaders only.

## Optional sync workflow

If you need to sync Codex → IDE registry, run:

```bash
/path/to/ops-standards/scripts/mcp-sync
```

`mcp-sync` accepts optional explicit paths, but defaults to common locations under `$HOME`.

## Secrets policy (system-wide)

Do not put tokens in `config.toml` or IDE MCP registry JSON files.

Preferred location for secrets (per service):

- `$HOME/.config/secrets/<service>/...`

### The one allowed secret reader

On a given host, pick **one** secrets loader script that reads encrypted secret files and exports environment variables (for example):

- `$HOME/.config/mcp-secrets/load.sh`

Everything else (Codex, IDEs, scripts, MCP clients) should consume **env vars only**.

## Client enforcement (required)

Use client-side controls to enforce tool safety:

- **Local-first**: prefer local MCPs before remote/public MCPs.
- **Approvals**: require approvals for tools that write files, run commands, or call paid APIs.
- **Allowlist**: set allowed tools per repo (and per task) to prevent accidental tool usage.
- **Paid APIs**: use Firecrawl only when explicitly requested (prefer SearxNG first).

### Standard env guard (local MCP)

All local MCP servers honor:

- `MCP_REQUIRE_CONFIRM=1` → tools that write or execute will require `confirm=true`.

Use this in shells that run Codex when you want strict confirmation behavior.

### AGENTS.md guidance (per repo)

Add a short MCP policy block to each repo’s `AGENTS.md`:

- allowed MCPs (local + remote)
- any forbidden MCPs (e.g. paid tools)
- when approvals are required
- when to switch from local → remote

Use the SRD-synced block template: `srd/agents-block.md` (sync with `scripts/sync-agents-srd.sh`).

## Knowledgebase retrieval (KB MCP)

For cross-repo reuse, expose ops-standards as a read-only knowledgebase via MCP.

This repo includes a small KB server:

- Entry point: `/opt/ops-standards/scripts/ops_standards_srd_mcp_server.py`
- Roots (allowlist): `OPS_SRD_ROOTS` (colon-separated `name=/path`)

Example:

```bash
export OPS_SRD_ROOTS="docs=/path/to/ops-standards/docs:srd=/path/to/ops-standards/srd"
```

## Why a dedicated KB server if repo-docs exists

`repo-docs` is great for searching across many synced repos.

An ops-standards KB server is intentionally smaller:

- it targets the canonical standards/runbook repo directly
- it avoids needing an indexing pipeline for “read/search docs now”
