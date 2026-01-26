# Versioning (ops-standards-portable)

## Purpose

This repo is a portable, host-agnostic standards bundle meant to be pulled onto other systems.
Releases signal when downstream hosts should update their local copy.

## Version format

`VERSION` uses a date-based scheme:

- `YYYY.MM.DD.N`
- `N` increments for multiple releases on the same date.

## When to cut a new release

Cut a new portable release when any of these change:

- Standards or policies under `srd/docs/`
- Bootstrap or sync scripts under `scripts/`
- Templates under `templates/`
- Portable Codex skills under `codex/skills/`
- Portable docs under `docs/`

Do **not** cut a portable release for CGP-only changes that live in ops-standards SRD.

## Release steps (minimal)

1) Update content in this repo.
2) Bump `VERSION`.
3) Tag the release with `portable-YYYY.MM.DD.N`.
4) Publish release notes (short bullets: what changed + why update is needed).

## Orchestrator note

`/opt/ops-standards` is the control-plane repo that orchestrates:

- `srd/docs/` (CGP SRD)
- `/opt/ops-standards-portable` (portable bundle)

Portable releases are cut from this repo when new standards must propagate to other hosts.
