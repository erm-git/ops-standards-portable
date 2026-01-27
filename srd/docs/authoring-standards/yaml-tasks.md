---
title: "YAML Tasks (CGP SRD)"
status: "standard"
---

## Rules (summary)

If a project uses YAML tasks:

- Folder placement is truth (`todo/`, `in-progress/`, `done/`).
- Task packets define `scope.touch_only` and required tests.
- Keep tasks small; keep a single YAML in progress.
- **Hard rule:** task files are written for **machine ingestion** (not humans). No ambiguity.

## Required fields (portable baseline)

- `id`
- `title`
- `objective` (concrete outcome only)
- `scope.touch_only`
- `steps` (explicit, ordered, atomic)
- `acceptance_checks`

## Status + completion

- `status:` only when in `in-progress/` or `done/`.
- `completion:` block required on done tasks.

## Codex CLI prereq (when needed)

If a task requires Codex CLI, declare it in `prereqs`:

```yaml
prereqs:
  tools:
    - name: codex-cli
      install: "npm install -g @openai/codex"
      verify: "codex --version"
```
