---
title: "Linux Seed (Portable)"
status: "standard"
---

## Goal

Seed a Linux host (including WSL) with the same baseline layout used on CGP, without installing CGP-specific packages.

## WSL hostname (optional)

```bash
sudo hostnamectl set-hostname wsl-ubuntu-24-04
```

If you set a hostname, add it to `/etc/hosts` and restart WSL.

## Tracking clone + live copy (portable standard)

Tracking clone (portable baseline):

```bash
sudo mkdir -p /srv/dev/ops-standards-portable
sudo chown "$USER":"$USER" /srv/dev/ops-standards-portable

git clone git@github.com:erm-git/ops-standards-portable.git /srv/dev/ops-standards-portable
```

Live copy (host-used path):

```bash
sudo mkdir -p /opt/ops-standards
sudo chown "$USER":"$USER" /opt/ops-standards
```

### One-time template copy (recommended)

If you want templates in the live copy (so SRD block updates apply there too):

```bash
mkdir -p /opt/ops-standards/templates
rsync -a /srv/dev/ops-standards-portable/templates/ /opt/ops-standards/templates/
ls -la /opt/ops-standards/templates
```

If you skip this, template block sync will skip templates (no targets).

### Optional: install sync script in live copy

If you want a stable path under `/opt/ops-standards/scripts/`:

```bash
mkdir -p /opt/ops-standards/scripts
cp /srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh /opt/ops-standards/scripts/

# Use tracking clone as source when running from live copy
/opt/ops-standards/scripts/sync-from-upstream.sh --live /opt/ops-standards --tracking /srv/dev/ops-standards-portable
```

### Important rule (no rsync into local SRD)

Do **not** `rsync --delete` portable `srd/` into local `srd/`. That overwrites host‑local SRD additions.

Portable updates flow through **SRD block sync** only.

## Host-local SRD additions (safe)

Keep host‑specific SRD additions here:

```
/opt/ops-standards/srd/docs/<host>/...
```

This folder is never overwritten by portable updates.

### Host-local SRD stub (optional)

```bash
HOST_SLUG="my-host"
mkdir -p "/opt/ops-standards/srd/docs/${HOST_SLUG}"
cat > "/opt/ops-standards/srd/docs/${HOST_SLUG}/README.md" <<'EOF'
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
cd /srv/dev/ops-standards-portable

git pull --ff-only

# Optional: review updates in the portable baseline
# (block sync will only update SRD blocks in local core docs/templates)

/srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh --live /opt/ops-standards
/srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh --live /opt/ops-standards --apply
```

The sync script:

- updates SRD blocks in the core docs set
- logs missing markers instead of overwriting
- updates `VERSION`

## Existing host update (short form)

Use this on hosts that already have `/opt/ops-standards`:

```bash
cd /srv/dev/ops-standards-portable
git pull --ff-only

# One-time template copy if missing
mkdir -p /opt/ops-standards/templates
rsync -a /srv/dev/ops-standards-portable/templates/ /opt/ops-standards/templates/

/srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh --live /opt/ops-standards
/srv/dev/ops-standards-portable/scripts/sync-from-upstream.sh --live /opt/ops-standards --apply
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
