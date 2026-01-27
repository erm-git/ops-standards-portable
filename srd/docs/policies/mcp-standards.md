# MCP Standards (CGP)

Goal: ensure Codex (CLI and IDE clients) can reliably use MCP servers with a consistent secrets workflow.

## Source of truth

- Codex CLI MCP registry (recommended source of truth): `~/.codex/config.toml`
- The **MCP stack** is the set of MCP servers declared in `~/.codex/config.toml` (local + public).

## Migration Preflight Checklist

- Update Codex MCP registry: `~/.codex/config.toml`
- Update systemd units: `/etc/systemd/system/*.service` and `*.timer`
- Update wrappers: `/usr/local/bin` and `/usr/local/sbin`
- Update repo scripts/configs: scan `/srv/dev` and `/opt` for `/opt/tools` references
- Update docs: `srd/docs/tools/mcp-servers-index.md` and related MCP docs
- Create compatibility symlinks: `/opt/tools/<name>` -> `/opt/<project>`
- Validate MCP clients can start servers under new paths
- Remove legacy aliases and `/opt/tools` symlinks only after validation

## Portable Defaults

- ops-standards-srd
- searxng
- text-etl (CPU)
- github-search-local
- web.run (remote tool; not a local server)

## Portable Optional

- reddit-mcp
- czkawka
- text-etl-gpu (GPU only)
- firecrawl (niche, paid, confirm-only)

## Non-Defaults

- repo-docs
- rpg-srd
- vscode-etl
- huggingface_local

Some environments also have an IDE-side MCP registry (for example VS Code Remote). If your IDE requires its own registry, treat `~/.codex/config.toml` as the source and sync it to the IDE registry.

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

- `$HOME/.config/secrets/load.sh`

Everything else (Codex, IDEs, scripts, MCP clients) should consume **env vars only**.

## Client enforcement (required)

Use client-side controls to enforce tool safety:

- **Local-first**: prefer local MCPs before remote/public MCPs.
- **Approvals**: require approvals for tools that write files, run commands, or call paid APIs.
- **Allowlist**: set allowed tools per repo (and per task) to prevent accidental tool usage.

## Tool order (hard rules)

When multiple tools can satisfy a request, follow this order:

1) **Local KB first**: `ops-standards-srd` for standards/policies.
2) **Local indexes**: `repo-docs`, `rpg-srd`, `vscode-etl` (whichever matches the corpus).
3) **Local web search**: `searxng` for discovery/search.
4) **Web lookup**: `web.run` (citations or broader coverage) when SearxNG is weak or sources are required.
5) **Rendered fetch**: `playwright` (if available) for JS-heavy pages or dynamic content.
6) **Paid web extraction**: Firecrawl **only if explicitly requested** or if the user approves after you ask (niche use).

If a step yields the answer, stop there and do not escalate to later tools.

## Tool selection rules (when to use what)

- **OpenAI docs**: always use the OpenAI Developer Docs MCP first (official, up‑to‑date).
- **GitHub data**:
  - use **official GitHub MCP** for repo/issue/PR/content operations.
  - use **local `github_search_local`** for discovery/scouting only.
- **Hugging Face**:
  - use **local `huggingface_local`** for controlled downloads and local cache‑aware queries.
  - use **official HF MCP** for community tools/Spaces or broad discovery.
- **Web search**:
  - use **`searxng`** first.
  - use **`web.run`** for citations or wider coverage if SearxNG results are weak.
  - use **`playwright`** only when a rendered/JS page is required.
  - use **Firecrawl** only when a page must be scraped and the user approves paid usage (niche).
- **Text extraction**:
  - use **`text-etl-*`** for PDFs/HTML/ETL pipelines; do not use Firecrawl for large ETL flows.
- **Reddit**:
  - use **`reddit-mcp`** for ingestion; use `searxng` only for URL discovery.

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

Use the SRD-synced block template: `srd/docs/policies/agents-block.md` (sync with `scripts/sync-agents-srd.sh`).

## Knowledgebase retrieval (KB MCP)

For cross-repo reuse, expose ops-standards as a read-only knowledgebase via MCP.

This repo includes a small KB server:

- Entry point: `/opt/tools/ops-standards/ops_standards_srd_mcp_server.py`
- Roots (allowlist): `OPS_SRD_ROOTS` (colon-separated `name=/path`)

Example:

```bash
export OPS_SRD_ROOTS="docs=/path/to/ops-standards/docs:srd=/path/to/ops-standards/srd/docs:portable_docs=/path/to/ops-standards/portable-srd/docs:portable_srd=/path/to/ops-standards/portable-srd/srd/docs"
```

## Why a dedicated KB server if repo-docs exists

`repo-docs` is great for searching across many synced repos.

An ops-standards KB server is intentionally smaller:

- it targets the canonical standards/runbook repo directly
- it avoids needing an indexing pipeline for “read/search docs now”
