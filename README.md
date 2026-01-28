# Portable Ops Standards

Canonical quick start for the portable, host-agnostic ops-standards bundle.

## Quick start (new repo seed)

```bash
scripts/bootstrap.sh --target /path/to/project \
  --title "My Project" \
  --one-line "One sentence summary" \
  --purpose "Short paragraph purpose"
```

The target directory is created if it does not exist. By default this writes
only missing files (idempotent).

Note: if you create host-level directories with `sudo` (for example under
`/opt`, `/srv`, or `/var/opt`), remember to set ownership for the intended
user/service account (commonly `sudo chown -R "$USER:$USER" <path>` on
single-user boxes).

## What this is (and is not)

- This is a portable baseline.
- This is not a full backup/NAS/offsite implementation guide (those are host SRD concerns).

## Design goals

- No hostnames, IPs, mountpoints, or appliance/vendor specifics.
- Keep the scope to structure and collaboration standards (docs shape, FHS layout, Codex/AGENTS, etc.).
- Provide a bootstrap script + Codex skill so it’s easy to apply consistently.
- Avoid hardcoding UIDs/GIDs; prefer `$USER:$USER` where appropriate.

## Contents

- `templates/` — template files to copy into a target repo
- `scripts/seed-live.sh` — seeds a live ops-standards copy (repo root + docs + templates + SRD block sync)
- `codex/skills/codex-new-project/` — Codex skill to seed a new project
- `VERSION` — portable bundle version

## Update model for host installs

Tracking clone + live copy (no SRD rsync):

- Tracking clone: `${TRACKING_ROOT}` (defaults in `docs/linux-seed.md`)
- Live copy: `${LIVE_ROOT}` (defaults in `docs/linux-seed.md`)
- Updates flow via **SRD block sync** only (no rsync into local `srd/`).
- Use `scripts/seed-live.sh` for seeding (do not improvise).

## Seed a host (live ops-standards)

Use this when seeding `/opt/ops-standards` from a tracking clone:

```bash
scripts/seed-live.sh --live /opt/ops-standards --apply
```

## Docs and references

- `docs/index.md` for the portable docs landing page.
- `docs/bootstrap.md` for bootstrap details.
- `docs/core-docs.md` for the core docs contract.
- `docs/linux-seed.md` for the tracking clone + live copy update model.

## Bootstrap a repo (Codex skill)

Install the vendored skills into `$CODEX_HOME/skills`:

```bash
scripts/install-codex-skill.sh --apply
```

Then ask Codex to run the `codex-new-project` skill.

## Offline standards copy

- `srd/` contains the host-agnostic standards subset (no CGP runbooks).

## Versioning convention

`VERSION` uses a date-based convention:

- `YYYY.MM.DD.N`

Rules:

- `YYYY.MM.DD` is the date you cut the portable bundle.
- `N` increments if you cut multiple bundles on the same day.
