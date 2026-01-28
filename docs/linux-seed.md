---
title: "Linux Seed (Portable)"
status: "standard"
---

## Agent entry (machine instructions)

Canonical procedure for seeding any Linux host from the portable baseline.
Do not improvise. Follow the steps exactly.

## Goal

Seed `/opt/ops-standards` from the portable tracking clone and keep it updateable.

## Path defaults (override only if required)

```bash
TRACKING_ROOT="/srv/dev/ops-standards-portable"
LIVE_ROOT="/opt/ops-standards"
```

## Required procedure (all hosts)

**Rule:** clone **only** `ops-standards-portable`. Do not clone `ops-standards` separately.
**Rule:** always pull the tracking clone before following instructions.  
If VERSION changes after pull, re-open this file and restart from Step 1.

Step 1 — ensure tracking clone exists and is current:

```bash
if [ ! -d "${TRACKING_ROOT}/.git" ]; then
  sudo mkdir -p "$(dirname "${TRACKING_ROOT}")"
  sudo chown "$USER":"$USER" "$(dirname "${TRACKING_ROOT}")"
  git clone git@github.com:erm-git/ops-standards-portable.git "${TRACKING_ROOT}"
else
  git -C "${TRACKING_ROOT}" pull --ff-only
fi
cat "${TRACKING_ROOT}/VERSION"
```

Step 2 — ensure live copy exists:

```bash
sudo mkdir -p "${LIVE_ROOT}"
sudo chown "$USER":"$USER" "${LIVE_ROOT}"
```

Step 3 — seed/update live copy (required; do not improvise):

```bash
"${TRACKING_ROOT}/scripts/seed-live.sh" --live "${LIVE_ROOT}" --apply
```

Notes:
- `seed-live.sh` pulls the tracking clone by default; use `--no-pull` only if you are offline.
- `seed-live.sh` performs template seeding, SRD block sync (dry‑run + apply), and VERSION verification.
- `seed-live.sh` does **not** run sudo; `${LIVE_ROOT}` must already exist and be writable.

Step 4 — verify:

```bash
cat "${LIVE_ROOT}/VERSION"
```

Step 5 — optional (manual, last step only): local git repo

This is **not required** and **must not be automated**.  
Only run if the system is nominal, files are correct, and the human explicitly requests it.

```bash
# local-only bare repo (no GitHub remote by default)
sudo mkdir -p /srv/git
sudo chown "$USER":"$USER" /srv/git
git init --bare /srv/git/ops-standards.git
git -C "${LIVE_ROOT}" init
git -C "${LIVE_ROOT}" remote add local "/srv/git/ops-standards.git" 2>/dev/null || true
git -C "${LIVE_ROOT}" push --mirror local
```

## Hard rules

- Do **not** `rsync --delete` portable `srd/` into local `srd/`.
- Do **not** run `sync-from-upstream.sh` directly (it is already called by `seed-live.sh`).
- Only run `seed-live.sh` for seed/update.
- Reports must list **only** the allowed commands in this document. No extras.

## Host-local SRD additions (safe)

Keep host-specific SRD additions here:

```
${LIVE_ROOT}/srd/docs/<host>/...
```

This folder is never overwritten by portable updates.
