---
title: "VS Code Standards"
status: "standard"
---

## Goals

- Keep editor behavior consistent across machines.
- Avoid repo-specific surprises when collaborating with humans + agents.

## Portable baseline

- Put repo-specific settings in `.vscode/settings.json` (seeded by bootstrap).
- Put recommended extensions in `.vscode/extensions.json` (seeded by bootstrap).
- Keep secrets out of `.vscode/` (no tokens, no plaintext env files).

## Workspace usage

- Prefer opening the repo root as the workspace.
- Keep per-repo tasks simple and documented in `README.md`.
