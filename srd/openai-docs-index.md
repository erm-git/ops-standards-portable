---
title: "OpenAI Docs MCP Index (Portable SRD)"
status: "living"
---

## Purpose

Quick index of what the OpenAI Docs MCP can answer so requests can be fuzzy.

## Core Codex queries (start here)

Use these as search phrases with the OpenAI Docs MCP:

- `Codex` (landing, overview)
- `Codex CLI` (CLI reference, install/usage)
- `AGENTS.md` (agents-md guide)
- `config.toml` (Codex config reference)
- `skills` (skills overview + create-skill)
- `MCP` (Docs MCP and config)
- `Codex prompting guide`

## Model + deprecation queries

- `codex-mini-latest`
- `gpt-5-codex` / `gpt-5.2-codex`
- `deprecations codex`
- `model snapshot codex`

## CLI / IDE update checks

After a Codex CLI or IDE update, re-check:

- `Codex CLI` (reference + changes)
- `config-reference` (new config keys)
- `AGENTS.md` (instruction precedence)
- `skills` (format/fields)

## MCP usage (how to query)

Preferred flow:

1) `list_openai_docs(limit=…)` to confirm connectivity.  
2) `search_openai_docs(query=…)` with a short phrase.  
3) `fetch_openai_doc(url=…)` for the exact section.

