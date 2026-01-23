---
name: ops-new-workspace
description: "Seed a repo with portable core docs using the portable bootstrap (host-agnostic)."
metadata:
  short-description: Bootstrap core docs (portable)
---

# Ops New-Workspace (portable)

Use this skill to start a new project/workspace directory with the **portable** core docs set.

## What it does

- Prompts for project metadata (title, one-line summary, purpose)
- Creates the target directory if missing
- Runs the portable bootstrap (vendored when installed)

## How to run

Run the bundled helper:

```bash
codex/skills/ops-new-workspace/scripts/newworkspace.sh
```
