---
title: "Git Hygiene (Portable SRD)"
status: "standard"
---

## Goal

Keep histories reviewable and mirrors/backups consistent.

## Short standard (TL;DR)

- Default branch is `main`; do not rewrite shared history.
- Use two remotes: `origin` (upstream) and `local` (`/srv/git/<project>.git`).
- Prefer small, logical commits; split docs/code/config when practical.
- Use concise, imperative commit messages.
- `git review-ready` never commits or pushes; `git publish` stages + commits + pushes.

## Branch policy

- Default branch: `main`
- Avoid history rewrites on shared branches.

## Remotes (local convention)

- `origin`: upstream host (e.g., GitHub)
- `local`: local bare mirror under `/srv/git/<project>.git` (if you keep bare mirrors)

Example:

```bash
git remote add origin git@github.com:ORG/REPO.git
git remote add local /srv/git/<project>.git
```

## Commit policy

- Prefer multiple small commits over one “everything” commit.
- Each commit should be one logical change set (docs vs code vs config vs scripts).
- Commit messages: short, specific, imperative.

## Chunking guidance (fuzzy logic)

When grouping changes for `git publish`, use these heuristics (not strict rules):

Order of separation:
1) **Docs vs code vs config vs scripts** (separate by category first)
2) **By feature or task** (if a change spans multiple files for one outcome, keep together)
3) **By directory** (last resort if changes are independent)

If unsure, default to **fewer, coherent commits** rather than over-splitting.

## Standard agent phrases (behavior contracts)

### `git review-ready`

- stage only clearly intended changes
- no branch changes, rebase, reset, clean, commit, or push
- output: `git status -sb`, `git diff --cached --stat`, `git diff --cached`

### `git checkpoint`

- create a local commit only
- no push

### `git publish`

- stage + commit + push (to configured remotes)

## Standard make entrypoints (recommended)

Use `make git-*` names so the domain is obvious:

- `make git-review-ready`
- `make git-checkpoint`
- `make git-publish`
- optional: `make git-publish-chunked`
