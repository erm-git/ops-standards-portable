# Skill: portable-ops-sync

## Purpose

Sync portable content from the tracking clone into the live copy:
`srd/`, `templates/`, and `VERSION` only.

## Requirements

- You must provide the live path (`LIVE_ROOT`), e.g. `/opt/ops-standards`.
- Always run dry-run first and show output before applying.

## Commands (run in tracking clone)

Dry-run:

```bash
LIVE_ROOT=/opt/ops-standards scripts/sync-from-upstream.sh --live "$LIVE_ROOT"
```

Apply (only after human confirmation):

```bash
LIVE_ROOT=/opt/ops-standards scripts/sync-from-upstream.sh --live "$LIVE_ROOT" --apply
```

## Notes

- Do not sync any other folders.
- Do not edit the live copy directly.
