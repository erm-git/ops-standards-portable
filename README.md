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
- `scripts/bootstrap.sh` — seeds a target repo with these templates
- `codex/skills/portable-ops-bootstrap/` — Codex skill wrapper for the bootstrap script
- `VERSION` — portable bundle version

## Update model for host installs

Tracking clone + live copy (partial sync only):

- Tracking clone: `/srv/dev/ops-standards-portable`
- Live copy: `/opt/ops-standards`
- Sync only: `srd/`, `templates/`, and `VERSION` (no full-repo rsync)

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

Then ask Codex to run the `portable-ops-bootstrap` skill.

## Offline standards copy

- `srd/` contains the host-agnostic standards subset (no CGP runbooks).

## Versioning convention

`VERSION` uses a date-based convention:

- `YYYY.MM.DD.N`

Rules:

- `YYYY.MM.DD` is the date you cut the portable bundle.
- `N` increments if you cut multiple bundles on the same day.
