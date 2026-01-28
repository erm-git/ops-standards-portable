---
name: codex-new-project
description: "Seed a repo with core docs using the standard bootstrap."
metadata:
  short-description: Bootstrap core docs (portable)
---

# Codex New-Project

Use this skill to start a new project directory with the core docs set.

## What it does

- Prompts for project metadata (title, one-line summary, purpose)
- Creates the target directory if missing
- Runs the portable bootstrap (vendored when installed)

## How to run

Run the bundled helper:

```bash
codex/skills/codex-new-project/scripts/newproject.sh
```
