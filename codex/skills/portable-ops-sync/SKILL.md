# Skill: portable-ops-sync

## Purpose

Sync SRD blocks from the tracking clone into the live copy.
Only the SRD blocks and `VERSION` are updated; no rsync overwrite of `srd/`.

## Requirements

- Provide the live path (`LIVE_ROOT`). Default is `/opt/ops-standards`.
- Run dry-run first and review output before apply.

## Commands (run in tracking clone)

Dry-run:

```bash
LIVE_ROOT="${LIVE_ROOT:-/opt/ops-standards}"
scripts/sync-from-upstream.sh --live "$LIVE_ROOT"
```

Apply (only after human confirmation):

```bash
LIVE_ROOT="${LIVE_ROOT:-/opt/ops-standards}"
scripts/sync-from-upstream.sh --live "$LIVE_ROOT" --apply
```

## Notes

- Do not rsync `srd/` into the live copy.
- Only SRD blocks and `VERSION` should change.
