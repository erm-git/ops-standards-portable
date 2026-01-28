---
title: "MCP Servers Index (Portable)"
status: "living"
---

# MCP Servers Index (Portable)

Purpose: list the portable baseline MCP servers and the optional/public servers that can be added on any host.

## Source of truth

- Codex CLI registry: `~/.codex/config.toml` (authoritative)

## Naming conventions (local MCP)

- Use lowercase + hyphens.
- Use `-local` suffix when a public server exists for the same domain (example: `github-search-local`).
- Keep public MCP names as published by the provider.

## Portable defaults (local, stdio)

These are the default local servers for portable systems. Paths assume `/opt/<project>` layout.

- **ops-standards-srd**
  - Entry point: `/opt/ops-standards/scripts/ops_standards_srd_mcp_server.py`
  - Env: `OPS_SRD_ROOTS` (at minimum `srd=/opt/ops-standards/srd/docs`)

- **searxng**
  - Entry point: `/opt/searxng/searxng_mcp_server.py`

- **text-etl** (CPU)
  - Entry point: `/opt/text-etl/text_etl_core_mcp_server.py`
  - Includes `playwright_fetch` tool (no standalone Playwright MCP required by default)

- **github-search-local**
  - Entry point: `/opt/github-search/mcp_server.py`
  - Env: `GITHUB_TOKEN` (or use `gh auth token` in the wrapper)

- **web.run** (remote tool)
  - Not a local MCP server. It is a remote tool available via the OpenAI client.

## Optional local servers (portable)

- **text-etl-gpu** (GPU only)
  - Entry point: `/opt/text-etl/text_etl_gpu_mcp_server.py`

- **reddit-mcp**
  - Entry point: `/opt/reddit-mcp/mcp_server.py`

- **czkawka**
  - Entry point: `/opt/czkawka/mcp_server.py`

- **playwright (standalone)**
  - Optional only. If installed, tool names must mirror the Microsoft Playwright MCP tool set.

- **firecrawl** (paid)
  - Optional only. Require explicit user confirmation before use.

## Non-default local servers (only if installed)

These are not part of the portable baseline. Add only on hosts that install them.

- **repo-docs** → `/opt/repo-docs/mcp_server.py`
- **rpg-srd** → `/opt/rpg-srd/mcp_server.py`
- **vscode-etl** → `/opt/vscode-etl/scripts/mcp/vscode_chatlogs_mcp.py`
- **huggingface-local** → `/opt/huggingface-local/huggingface_mcp_server.py`

## Public/official servers (HTTP)

- **GitHub MCP**
  - Codex name: `github-mcp-server`
  - URL: `https://api.githubcopilot.com/mcp/`
  - Auth: `GITHUB_MCP_AUTHORIZATION` (Bearer token)

- **Hugging Face MCP**
  - Codex name: `hf-mcp-server`
  - URL: `https://huggingface.co/mcp?login`
  - Auth: `HF_TOKEN` or `HF_MCP_AUTHORIZATION` (depends on client)

- **OpenAI Developer Docs MCP**
  - Codex name: `openaiDeveloperDocs`
  - URL: `https://developers.openai.com/mcp`
