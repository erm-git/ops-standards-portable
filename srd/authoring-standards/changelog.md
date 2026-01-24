---
title: "Changelog Standards (Portable SRD)"
status: "standard"
---

## Purpose

`CHANGELOG.md` is a curated, chronological list of notable changes.

Include changes that affect how someone uses/operates the repo:

- new or changed standards (secrets, backups, MCP, naming)
- workflow contracts (task lifecycle, update discipline, “folder truth” rules)
- new scripts/automation used by normal workflows
- removals/retirements of major structures (template dirs, repo scaffolds)

Skip noise:

- tiny typo fixes
- pure formatting reflows
- internal refactors with no behavior change (unless they affect how to run/operate)

Rule of thumb:

- If a user/operator would care about the change, add it.
- Update the changelog in the same change that introduces the behavior/policy shift.
- Local-only artifacts (reports) do not go in the changelog.

## Format

- Keep an `[Unreleased]` section at the top.
- Use change types when applicable: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.
- Use ISO dates: `YYYY-MM-DD`.
