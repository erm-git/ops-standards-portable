---
title: "MCP Servers Index (CGP SRD)"
status: "living"
---

# MCP Servers Index (local + official)

This file is a quick index of the host **MCP stack** (the set of MCP servers configured and available on this machine): what they are, where they live, and how they’re configured.

## Where MCP is configured

- Codex CLI: `~/.codex/config.toml`
- VS Code Remote (server-side): `~/.vscode-server/data/User/mcp.json`
- VS Code local: `~/.config/Code/User/mcp.json` (currently empty on this machine)

## Portable Defaults vs Optional

- Defaults: ops-standards-srd, searxng, text-etl (CPU), github-search-local
- Optional: reddit-mcp, czkawka, text-etl-gpu, firecrawl

## Auth env wiring (why shells load “secrets”)

Some HTTP MCP servers expect auth in environment variables:

- GitHub official MCP expects `GITHUB_MCP_AUTHORIZATION` (typically `Bearer <token>`)
- Hugging Face official MCP expects either `HF_TOKEN` or `HF_MCP_AUTHORIZATION` depending on client config

On this machine those variables are populated by `~/.config/secrets/load.sh` (sourced by `~/.profile`).

## Local servers (stdio, run as a local process)

These are installed under `/opt/tools` (or symlinked from there) and are started by your MCP client using a `command` + `args` config.

### GitHub (local)

- **Codex name:** `github_search_local`
- **VS Code Remote name:** `github_search_local`
- **Entry point:** `/opt/tools/github-search/mcp_server.py`
- **What it does:** lightweight GitHub discovery/search helpers (wrapping local scripts like `gh-api-search` / `gh-etl-scout`)
- **Notes:** uses `GITHUB_TOKEN` (directly or via `gh auth token`) for API access; does not attempt to mirror the full GitHub platform toolset.

### Hugging Face (local)

- **Codex name:** `huggingface_local`
- **VS Code Remote name:** `huggingface_local`
- **Entry point (symlink):** `/opt/tools/hugging-face/huggingface_mcp_server.py`
- **Real path:** `/opt/llm-stack/hf-tools/huggingface_mcp_server.py`
- **What it does:** Hugging Face Hub search + metadata + controlled local downloads (e.g. download a file/snapshot into allowed write roots)
- **Key env:** `HF_TOKEN` (optional), `HF_HOME`, `HF_HUB_CACHE`, `HF_DOWNLOAD_ROOT`, `HF_MCP_WRITE_ROOTS`

### Other local MCP servers shipped under /opt/tools

These are also used by Codex on this machine (see `~/.codex/config.toml` for exact names/env):

- `/opt/tools/searxng/searxng_mcp_server.py` — local SearxNG web search
- `/opt/tools/catacomb-core-planner/searxng_mcp_server.py` — SearxNG web search (planner-flavored wrapper)
- `/opt/tools/catacomb-core-planner/text_etl_core_mcp_server.py` — text-etl CPU workflows (planner-flavored wrapper)
- `/opt/tools/catacomb-core-planner/text_etl_gpu_mcp_server.py` — text-etl GPU workflows (planner-flavored wrapper)
- `/opt/tools/repo-docs/mcp_server.py` — local indexed docs search/read for `/srv/dev/repo-docs`
- `/opt/tools/rpg-srd/docs/mcp_server.py` — local indexed SRD search/read for `/srv/dev/rpg-srd`
- `/opt/tools/rpg-srd/docs/rpg_srd_text_etl_mcp_server.py` — rpg-srd ETL workflows
- `/opt/tools/text-etl/text_etl_core_mcp_server.py` — text-etl CPU workflows
- `/opt/tools/text-etl/text_etl_gpu_mcp_server.py` — text-etl GPU workflows
- `/opt/tools/reddit-mcp/mcp_server.py` — reddit ingestion (PRAW via text-etl CLI)
- `/opt/tools/catacomb-core/mcp_server.py` — catacomb-core helpers (docs/YAML access + harness/test wrappers)
- `/opt/tools/czkawka/mcp_server.py` — safe duplicate-finder wrappers (policy/allowlist guarded)
- `/opt/tools/firecrawl/mcp_server.py` and `/opt/tools/firecrawl/credit_mcp_server.py` — Firecrawl integration (paid; avoid unless explicitly requested)

## Official/public servers (HTTP, hosted)

These are “remote MCP servers” configured by URL and used via OAuth or tokens.

### GitHub official MCP

- **Codex name:** `github-mcp-server`
- **VS Code Remote name:** `io.github.github/github-mcp-server`
- **URL:** `https://api.githubcopilot.com/mcp/`
- **Auth env (typical):** `GITHUB_MCP_AUTHORIZATION`
- **What it does:** broad GitHub platform toolset (repos/files, issues/PRs, Actions, etc.); supports OAuth flows in hosts that implement it.

### Hugging Face official MCP

- **Codex name:** `hf-mcp-server`
- **VS Code Remote name:** `huggingface/hf-mcp-server`
- **URL:** `https://huggingface.co/mcp?login`
- **Auth env (depends on config):** `HF_TOKEN` or `HF_MCP_AUTHORIZATION`
- **What it does:** Hub exploration + integrates community MCP tools via Spaces (great for “find and use a tool hosted on HF”).

### OpenAI Developer Docs MCP

- **Codex name:** `openaiDeveloperDocs`
- **VS Code Remote name:** `openaiDeveloperDocs`
- **URL:** `https://developers.openai.com/mcp`
- **What it does:** search/read OpenAI developer documentation via MCP.
