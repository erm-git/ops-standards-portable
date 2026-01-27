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

Tracking clone (source of truth):

```bash
sudo mkdir -p /srv/dev
sudo chown "$USER":"$USER" /srv/dev
git clone git@github.com:erm-git/ops-standards-portable.git /srv/dev/ops-standards-portable
```

Live copy (host-used path, partial sync only):

```bash
sudo mkdir -p /opt/ops-standards
sudo chown "$USER":"$USER" /opt/ops-standards
rsync -a --delete /srv/dev/ops-standards-portable/srd/ /opt/ops-standards/srd/
rsync -a --delete /srv/dev/ops-standards-portable/templates/ /opt/ops-standards/templates/
rsync -a /srv/dev/ops-standards-portable/VERSION /opt/ops-standards/VERSION
```

Update flow (manual review before apply):

```bash
cd /srv/dev/ops-standards-portable
git pull --ff-only
diff -ruN /opt/ops-standards/srd /srv/dev/ops-standards-portable/srd | less
diff -ruN /opt/ops-standards/templates /srv/dev/ops-standards-portable/templates | less
rsync -a --delete /srv/dev/ops-standards-portable/srd/ /opt/ops-standards/srd/
rsync -a --delete /srv/dev/ops-standards-portable/templates/ /opt/ops-standards/templates/
rsync -a /srv/dev/ops-standards-portable/VERSION /opt/ops-standards/VERSION
```

Optional helper (same flow, dry-run by default):

```bash
LIVE_ROOT=/opt/ops-standards scripts/sync-from-upstream.sh --live "$LIVE_ROOT"
LIVE_ROOT=/opt/ops-standards scripts/sync-from-upstream.sh --live "$LIVE_ROOT" --apply
```

Do not edit `/opt/ops-standards` directly. Use the tracking clone.
`/opt/ops-standards` is not expected to match upstream git commits.
Use `VERSION` plus the `srd/` and `templates/` diffs to confirm sync.

## Update discipline (no drift)

- Only pull updates in `/srv/dev/ops-standards-portable`.
- `/opt/ops-standards` is live copy only (never edit it directly).
- Review diffs for `srd/` and `templates/` only.
- Sync only `srd/`, `templates/`, and `VERSION` (no full-repo rsync).

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
