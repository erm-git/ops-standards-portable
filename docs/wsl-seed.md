---
title: "WSL Seed (Portable)"
status: "standard"
---

## Goal

Seed a WSL system with the same baseline layout used on CGP, without installing CGP-specific packages.

## WSL hostname (optional)

```bash
sudo hostnamectl set-hostname wsl-ubuntu-24-04
```

If you set a hostname, add it to `/etc/hosts` and restart WSL.

## Tracking clone + live copy (portable standard)

Tracking clone:

```bash
sudo mkdir -p /srv/dev
sudo chown "$USER":"$USER" /srv/dev
git clone git@github.com:erm-git/ops-standards-portable.git /srv/dev/ops-standards-portable
```

Live copy (the canonical WSL path):

```bash
sudo mkdir -p /opt/ops-standards
sudo chown "$USER":"$USER" /opt/ops-standards
rsync -a --delete /srv/dev/ops-standards-portable/ /opt/ops-standards/
```

Update flow (manual review before apply):

```bash
cd /srv/dev/ops-standards-portable
git pull --ff-only
diff -ruN /opt/ops-standards /srv/dev/ops-standards-portable | less
rsync -a --delete /srv/dev/ops-standards-portable/ /opt/ops-standards/
```

Do not edit `/opt/ops-standards` directly. Use the tracking clone.

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
