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

## Clone ops-standards (read-only)

Use SSH if you have keys configured, otherwise HTTPS.

```bash
git clone git@github.com:erm-git/ops-standards.git /opt/ops-standards
cd /opt/ops-standards
git remote set-url --push origin no_push
```

## Local bare repo (same pattern as CGP)

```bash
sudo mkdir -p /srv/git
sudo chown "$USER":"$USER" /srv/git
git clone --bare /opt/ops-standards /srv/git/ops-standards.git
cd /opt/ops-standards
git remote add local /srv/git/ops-standards.git
git push local main
```

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
