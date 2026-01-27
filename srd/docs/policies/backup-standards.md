# Backup Standards (CGP)

This doc standardizes a pragmatic backup model:

- high integrity for offsite backups
- fast rollback locally on the NAS
- bounded storage growth on a small ZFS pool

## Roles

- **Git**: versioned source of truth for code/config/docs.
- **DB backups**: the “state” you cannot rebuild (small, prunable artifacts).
- **ZFS snapshots (NAS)**: fast local rollback.
- **Restic (offsite)**: encrypted, point-in-time backups to object storage (e.g., B2).
- **Secrets (offsite)**: back up encrypted secret files offsite (see `srd/docs/policies/secrets-standards.md`).

## Preferred model (least disruptive)

Keep offsite backups as:

- **Dev host → restic → B2**

Add resiliency without duplicating large trees:

- **Dev host → NAS `git-mirror/`** (mirror bare git repos)
- **Dev host → NAS `backup/`** (DB-only backups, pruned)
- **NAS → ZFS snapshots** on `git-mirror/` and `backup/`

Avoid “full tree” mirroring of `/var/opt/<project>` unless a project has no better “state artifact”.

## NAS dataset layout (recommended)

Per project:

- `/mnt/vault/projects/<project>/git-mirror` (bare repo mirrors)
- `/mnt/vault/projects/<project>/backup` (DB backups and small exports)
- `/mnt/vault/projects/<project>/restic` (optional: on-NAS restic repos)

## Git mirrors (bare repos)

Mirror local bare repos (for example under `/srv/git/<project>.git`) into NAS `git-mirror/`.

Preferred behavior:

- log to journald (not ad-hoc log files)
- treat missing mounts as warnings (skip) instead of blocking boot

## DB backups (NAS)

For projects with SQLite/Postgres/etc:

- prefer DB-native backup artifacts (SQLite `.backup`, pg_dump, etc.)
- store as timestamped files under the project `backup/` dataset
- prune aggressively (e.g., keep 14 days)

This keeps the NAS copy small and recovery-friendly.

## ZFS snapshots (NAS-local rollback)

Create periodic snapshot tasks for:

- `vault/projects/<project>/git-mirror`
- `vault/projects/<project>/backup`

Practical starting point (adjust once you see churn and pool size):

- hourly snapshots, keep 48 (2 days)
- daily snapshots, keep 30 (1 month)

## Restore philosophy

In a “small NAS” model, restores are usually:

1) restore git history (git mirror)
2) restore DB backups (latest or point-in-time)
3) recreate runtime environment (venv/containers/caches) as needed
