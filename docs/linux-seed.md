---
title: "Linux Seed (Portable)"
status: "standard"
---

## Agent entry (machine instructions)

This file is the canonical, unambiguous procedure for seeding a Linux host.
Do not improvise. Follow the steps exactly.

## Goal

Seed a Linux host with the same baseline layout used on CGP, without installing CGP-specific packages.

## Path defaults (override only if required)

```bash
TRACKING_ROOT="/srv/dev/ops-standards-portable"
LIVE_ROOT="/opt/ops-standards"
```

## WSL hostname (optional)

```bash
sudo hostnamectl set-hostname wsl-ubuntu-24-04
```

If you set a hostname, add it to `/etc/hosts` and restart WSL.

## Tracking clone + live copy (portable standard)

**Rule:** clone **only** `ops-standards-portable`. Do not clone `ops-standards` separately.

Step 1 — tracking clone (portable baseline):

```bash
sudo mkdir -p "${TRACKING_ROOT}"
sudo chown "$USER":"$USER" "${TRACKING_ROOT}"

git clone git@github.com:erm-git/ops-standards-portable.git "${TRACKING_ROOT}"
```

Step 2 — live copy (host-used path):

```bash
sudo mkdir -p "${LIVE_ROOT}"
sudo chown "$USER":"$USER" "${LIVE_ROOT}"
```

Step 3 — seed live copy (required; do not improvise)

```bash
"${TRACKING_ROOT}/scripts/seed-live.sh" --live "${LIVE_ROOT}" --apply
```

Step 4 — optional: install sync script in live copy

If you want a stable path under `${LIVE_ROOT}/scripts/`:

```bash
mkdir -p "${LIVE_ROOT}/scripts"
cp "${TRACKING_ROOT}/scripts/sync-from-upstream.sh" "${LIVE_ROOT}/scripts/"

# Use tracking clone as source when running from live copy
"${LIVE_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}" --tracking "${TRACKING_ROOT}"
```

### Hard rule (no rsync into local SRD)

Do **not** `rsync --delete` portable `srd/` into local `srd/`. That overwrites host‑local SRD additions.

Portable updates flow through **SRD block sync** only.

## Host-local SRD additions (safe)

Keep host‑specific SRD additions here:

```
${LIVE_ROOT}/srd/docs/<host>/...
```

This folder is never overwritten by portable updates.

Step 6 — host-local SRD stub (optional)

```bash
HOST_SLUG="my-host"
mkdir -p "${LIVE_ROOT}/srd/docs/${HOST_SLUG}"
cat > "${LIVE_ROOT}/srd/docs/${HOST_SLUG}/README.md" <<'EOF'
# Host SRD (local)

This folder contains host-specific SRD additions.
EOF
```

## SRD block sync model (portable → local)

Core docs and templates receive portable updates **only** inside SRD blocks:

```
<!-- SRD:BEGIN -->
...portable content...
<!-- SRD:END -->
```

Rules:

- Portable repo is the source of truth for the SRD block.
- Local files keep everything **outside** the block.
- If a file is missing markers, the sync skips it (and logs).
- No deletions are applied to local files.

## Update flow (manual review before apply)

```bash
cd "${TRACKING_ROOT}"

git pull --ff-only

# Optional: review updates in the portable baseline
# (block sync will only update SRD blocks in local core docs/templates)

"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}"
"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}" --apply
```

The sync script:

- updates SRD blocks in the core docs set
- logs missing markers instead of overwriting
- updates `VERSION`
- does **not** create missing files (empty live roots will be skipped)

## Existing host update (short form)

Use this on hosts that already have `${LIVE_ROOT}`:

```bash
cd "${TRACKING_ROOT}"
git pull --ff-only

# Template copy (required)
mkdir -p "${LIVE_ROOT}/templates"
rsync -a "${TRACKING_ROOT}/templates/" "${LIVE_ROOT}/templates/"

"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}"
"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}" --apply
```

## Core docs SRD‑block targets

These files should contain SRD block markers on the host:

- `AGENTS.md`
- `README.md`
- `CHANGELOG.md`
- `docs/index.md`
- `docs/current-state.md`
- `docs/roadmap.md`
- `docs/active-work.md` (optional)

If any file lacks markers, add them once, then rerun block sync.

## Move a project to /opt (example)

If a project is currently under `~/projects/<name>`:

```bash
sudo mkdir -p /opt
sudo chown "$USER":"$USER" /opt
mv ~/projects/lab-monitoring /opt/lab-monitoring
cd /opt/lab-monitoring
git remote add local /srv/git/lab-monitoring.git
```

If you already have a local bare repo at `/srv/git/<name>.git`, keep using it.
