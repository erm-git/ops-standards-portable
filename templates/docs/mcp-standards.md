---
title: "MCP Standards"
status: "standard"
---

## Purpose

Keep tool integrations predictable across environments.

## Portable baseline

- Codex MCP configuration source of truth: `$CODEX_HOME/config.toml`
- Prefer environment variables for credentials (avoid embedding secrets in config files).
- Document required env vars in `docs/current-state.md` (names only, no secret values).
