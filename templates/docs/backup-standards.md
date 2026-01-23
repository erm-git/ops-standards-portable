---
title: "Backup Standards (Portable)"
status: "standard"
---

This document defines the portable concepts and decision points.
Implementation details (NAS vendor, offsite provider, tooling) are host-specific.

## Roles

- **Git**: versioned source of truth for code/config/docs.
- **State artifacts**: the minimum files you must restore to recover service state (e.g., DB dumps).
- **Local rollback**: fast rollback on your local storage system (e.g., snapshots).
- **Offsite**: encrypted copies stored away from the host.

## Portable baseline model

- Keep **code/config/docs** in Git.
- Define and regularly produce **state artifacts** (small, prunable).
- Maintain **one local copy** separate from the host when possible.
- Maintain **one offsite copy** for critical artifacts.

## What not to back up (by default)

- caches and build artifacts (rebuildable)
- venvs/node_modules (rebuildable)
- large derived indexes (rebuildable unless proven otherwise)
