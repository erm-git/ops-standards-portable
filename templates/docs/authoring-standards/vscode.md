---
title: "VS Code Practices"
status: "standard"
---

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
- Prefer CLI entrypoints (`make fmt`, `make lint`, `make test`) over editor-specific build logic.
