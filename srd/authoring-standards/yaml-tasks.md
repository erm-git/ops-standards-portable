---
title: "YAML Tasks (Portable SRD)"
status: "standard"
---

## Rules (summary)

If a project uses YAML tasks:

- Folder placement is truth (`drafts/`, `todo/`, `in-progress/`, `done/`).
- Task packets define `scope.touch_only` and required tests.
- Keep tasks small; keep a single YAML in progress by default.

This lifecycle is inspired by CC‑P’s internal YAML workflow, but simplified for general use.

## Slim task packet (required fields)

Minimum fields:

- `id` (unique, short)
- `title` (one line)
- `objective` (1–3 sentences)
- `scope.touch_only` (explicit file/dir allowlist)
- `acceptance_checks` (list of checks/tests)

Optional fields:

- `notes` (short)
- `risk` (low/med/high)
- `links` (references)

## Directory-as-state (invariant)

- `drafts/` → proposed tasks (not yet approved; **never executed**)
- `todo/` → approved tasks (ready to start)
- `in-progress/` → active task(s); single-flight by default
- `done/` → completed (history)

Do not add `status:` fields inside YAML; folder placement is the truth.

### Local overrides

If a repo allows more than one active task at a time, document the limit in `AGENTS.md` or the repo’s ops guide.

## Work tracking linkage

When a repo uses YAML tasks, active work items should point to task files, and planned work should live in `roadmap.md` with references to the task packet.

## Status field (required on moved tasks)

When a task is moved into `in-progress/` or `done/`, set `status:` in the YAML header to match the folder (`in-progress` or `done`).

## Completion block (required on done tasks)

When a task is moved to `done/`, add a short `completion:` block near the end of the YAML:

- what changed
- what was verified

Treat done tasks as historical evidence; do not edit them.

## Lifecycle helper (optional)

This repo ships a CCP‑aligned helper that moves tasks with `git mv` when possible and updates `status:`:

```bash
python3 scripts/yaml-task-lifecycle.py start yaml-tasks/todo/<task>.yml
python3 scripts/yaml-task-lifecycle.py finish yaml-tasks/in-progress/<task>.yml
```

## Example (slim)

```yaml
id: git-hygiene-tldr
title: Add short git hygiene standard
objective: Add a concise TL;DR section to srd/git-hygiene.md.
scope:
  touch_only:
    - srd/git-hygiene.md
acceptance_checks:
  - "srd/git-hygiene.md includes a TL;DR section"
```

## Preflight mode (recommended)

- Read-only preflight should list:
  - files to change (from `scope.touch_only`)
  - required checks to run
  - any blockers or missing context
