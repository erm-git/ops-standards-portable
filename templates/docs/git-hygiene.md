---
title: "Git Hygiene"
status: "standard"
---

## Goals

- Keep history reviewable.
- Keep backups/mirrors consistent.
- Minimize “lost work” risk.

## Branch convention

- Default branch name: `main`

## Remotes convention (portable baseline)

- `origin`: upstream host (typically GitHub)
- `local`: local bare mirror under `/srv/git/<project>.git`

Example:

```bash
git remote add origin git@github.com:ORG/REPO.git
git remote add local /srv/git/<project>.git
```

## Daily flow (recommended)

- Make small, scoped commits.
- Push both remotes frequently:

```bash
git push origin main
git push local main
```

## Guardrails

- Avoid rebasing or history rewrites on shared branches unless explicitly agreed.
- Prefer `main`-only workflows unless you need feature branches for longer work.

## Agent phrases (optional)

- `git review-ready`: stage-only review bundle; no commit/push.
- `git publish`: stage + commit + push (to configured remotes).
