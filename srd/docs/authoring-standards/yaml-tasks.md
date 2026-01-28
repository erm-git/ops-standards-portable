---
title: "YAML Tasks (CGP SRD)"
status: "standard"
---

## Rules (summary)

If a project uses YAML tasks:

- Folder placement is truth (`drafts/`, `todo/`, `in-progress/`, `done/`).
- `status:` is **required** and must match the folder.
- Use the **canonical template** and key order (see below).
- Task packets define `scope.touch_only` and required tests.
- Keep tasks small; keep a single YAML in progress by default.
- **Hard rule:** task files are written for **machine ingestion** (not humans). No ambiguity.

## Canonical template (required)

Use the canonical template and **do not reorder keys**:

- `srd/docs/authoring-standards/yaml-task-template.yml`

Required top‑level keys (order enforced):

1) id  
2) title  
3) filename  
4) milestone  
5) branch  
6) status  
7) entrypoint  
8) related  
9) scope  
10) goals  
11) non_goals  
12) implementation_notes  
13) acceptance_checks  
14) tests  
15) docs_discipline  
16) git_flow  
17) completion  

## Status + completion

- `status:` is required in **all** task files and must match the folder name.
- `completion:` block required on done tasks (brief summary + verification).

## Lifecycle helper (required)

This repo ships a CCP‑aligned helper that moves tasks with `git mv` when possible and updates `status:`:

```bash
python3 scripts/yaml-task-lifecycle.py start yaml-tasks/todo/<task>.yml
python3 scripts/yaml-task-lifecycle.py finish yaml-tasks/in-progress/<task>.yml
```

## Codex CLI prereq (when needed)

If a task requires Codex CLI, declare it in `prereqs`:

```yaml
prereqs:
  tools:
    - name: codex-cli
      install: "npm install -g @openai/codex"
      verify: "codex --version"
```
