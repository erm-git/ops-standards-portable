---
title: "Filesystem Layout (FHS-aligned)"
status: "standard"
---

These are **portable conventions** for where things live on a Linux host.

Goal: make “where to find X” predictable, and keep runtime data separate from versioned code.

## Standard roles

- `/opt/<project>`: optional, user-managed application/runtime code
- `/var/opt/<project>`: runtime data/state for the project
- `/srv/git/<project>.git`: local bare git repos (authoritative local push targets)
- `/srv/dev/<project>`: dev working trees (if separate from `/opt`)
- `/srv/docker/<project>`: docker compose/config
- `/srv/www/<project>`: web roots/static artifacts (if applicable)

## Notes

- Prefer **one canonical path per role** and use bind mounts if you have legacy paths.
- Avoid putting runtime state inside git working trees unless it is truly versioned configuration.
- If you create directories with `sudo` (for example under `/opt`, `/srv`, or `/var/opt`), remember to set ownership for the intended user/service account. For a single-user box, a common default is `sudo chown -R "$USER:$USER" <path>`.
