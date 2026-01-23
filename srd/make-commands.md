---
title: "Standard Make Commands (CGP SRD)"
status: "standard"
---

## Goal

Provide consistent, repo‑local commands that agents and humans can rely on.

## Required targets (when applicable)

- `make fmt` — format code
- `make lint` — lint code
- `make test` — run tests
- `make type` — type checking

## Docs targets (when docs exist)

- `make docs-build` — build docs (MkDocs or equivalent)
- `make docs-serve` — serve docs locally

## Git targets (recommended)

- `make git-review-ready`
- `make git-checkpoint`
- `make git-publish`

## Notes

- Targets should be thin wrappers over repo scripts or canonical tool commands.
- If a target does not apply, document it in `README.md` (do not leave broken targets).
