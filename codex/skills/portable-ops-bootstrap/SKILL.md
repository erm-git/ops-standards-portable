---
name: portable-ops-bootstrap
description: "Seed a repo with portable ops standards. The installed skill vendors the portable templates + bootstrap script so it can run without an ops-standards checkout."
---

# Portable Ops Bootstrap

## What it does

- Prompts for project metadata (title, one-line summary, purpose)
- Seeds the target directory with the portable templates
- Does not set up remotes, backups, or host-specific tooling

## How to run

Run the bundled helper:

```bash
codex/skills/portable-ops-bootstrap/scripts/bootstrap.sh
```

## Notes

- When installed via `scripts/install-codex-skill.sh`, the skill includes a vendored copy of the portable bundle under `vendor/`.
- When running from an `ops-standards` checkout, the script falls back to `scripts/bootstrap.sh`.
