---
title: "Bootstrap (Portable)"
status: "standard"
---

This repo provides a small, host-agnostic bootstrap script for seeding core docs into a new repo.

## Seed core docs into a repo

From an ops-standards checkout:

```bash
scripts/bootstrap.sh --target /path/to/project \
  --title "My Project" \
  --one-line "One sentence summary" \
  --purpose "Short paragraph purpose"
```

This script is idempotent by default (skips existing files). The target
directory is created if it does not exist.

Optional portable AGENTS block sync:

```bash
scripts/sync-agents-portable.sh /path/to/project/AGENTS.md
```

## Install ops-standards Codex skills (optional)

From an ops-standards checkout:

```bash
scripts/install-codex-skill.sh --apply
```
