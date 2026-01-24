---
title: "MCP Query Playbook (Portable SRD)"
status: "standard"
---

## Use order (local-first)

1) `ops-standards-srd` (canonical standards)
2) `repo-docs` (indexed local repos)
3) `rpg-srd` (RPG SRD corpus)
4) `vscode-etl` (chatlogs)
5) `searxng` (web discovery)
6) `text-etl-core` / `text-etl-gpu` (ingest/convert)
7) `reddit-mcp` (Reddit ingestion)
8) Firecrawl (only if explicitly requested)

For write/exec tools, set `MCP_REQUIRE_CONFIRM=1` and pass `confirm=true`.

## Query grammar (standard)

- **List**: “List `<scope>` …”
- **Search**: “Search `<scope>` for `<term>` …”
- **Read**: “Read `<doc|file|record>` …”
- **Summarize**: “Summarize `<doc|result>` …”
- **Status**: “Show status for `<job|task|server>` …”
- **Run**: “Run `<task>` with `<params>` …”

## Local MCPs

### ops-standards-srd

- **Buckets:** roots, list files, search docs, read doc
- **Phrases:** “List files under `srd/authoring-standards`”, “Search SRD for `git hygiene`”, “Read `srd/mcp-standards.md`”

### repo-docs

- **Buckets:** projects, paths, search, read, search sections
- **Phrases:** “Search repo-docs for `AGENTS.md`”, “Search sections for `backup health`”, “Read `docs/roadmap.md` in repo X”

### rpg-srd

- **Buckets:** search, read, search sections
- **Phrases:** “Search rpg-srd for `spellcasting`”, “Read `manuals/ose-classic/...`”

### vscode-etl

- **Buckets:** list projects, list sessions, read transcript, search project
- **Phrases:** “List sessions for project `catacomb-core`”, “Search project for `restic`”

### searxng

- **Buckets:** web search, domain filter, recency
- **Phrases:** “Search web for `restic prune strategy`”, “Search site:github.com for `fastmcp`”

### text-etl-core

- **Buckets:** fetch URLs, site mirror, html→md, pdf→md, docling, md→jsonl, jsonl enhance, playwright fetch
- **Phrases:** “Fetch URLs from list …”, “Mirror site to markdown …”, “Convert PDF to markdown …”

### text-etl-gpu

- **Buckets:** marker_single, surya_ocr, surya_layout, surya_table
- **Phrases:** “Run `surya_ocr` on `<file>`”, “Run `marker_single` on `<pdf>`”

### reddit-mcp

- **Buckets:** subreddit ingest, input URL list, searxng discovery
- **Phrases:** “Ingest subreddit `r/gamedev` with filters”, “Ingest reddit URLs from file …”, “Discover via SearxNG query then ingest”

### catacomb-core

- **Buckets:** task index, current state, roadmap, run tests
- **Phrases:** “List YAML tasks”, “Read current state”, “Run pytest …”

### czkawka

- **Buckets:** find duplicates
- **Phrases:** “Find duplicates under `<path>` with filters …”

### github_search_local

- **Buckets:** repo search, topic search, ETL scout
- **Phrases:** “Search GitHub for `<term>`”, “Find ETL repos with `<topic>`”

### huggingface_local

- **Buckets:** search models, search datasets, repo details, download file
- **Phrases:** “Search HF models for `<term>`”, “Download file `<path>` from `<repo>`”
