---
title: "VS Code Practices (CGP SRD)"
status: "standard"
---

## Goals

- Keep editor behavior consistent across repos.
- Keep agents and humans aligned (predictable formatting, tasks, and files).

## Files

If a repo uses VS Code settings, commit:

- `.vscode/settings.json`
- `.vscode/extensions.json`

Optional (only when used):

- `.vscode/tasks.json`
- `.vscode/launch.json`

## Rules

- Keep secrets out of `.vscode/` (no tokens, no plaintext env files).
- Keep tasks non-interactive by default (flags/env vars).
- Prefer opening the repo root as the workspace.

## Minimal baseline

- Formatting and linting should run with repo-standard commands (for example `make fmt`, `make lint`, `make test`).
- Avoid editor-specific build logic when a CLI entrypoint exists.
