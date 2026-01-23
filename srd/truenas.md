# TrueNAS (CGP) — Ops Notes

This page captures TrueNAS workflows in a way that stays “appliance-friendly”:

- prefer UI/API and supported features
- avoid installing extra packages on the NAS host unless required

## Standard dataset layout (projects)

Recommended per-project dataset layout:

- `/mnt/vault/projects/<project>/git-mirror` (bare git mirrors)
- `/mnt/vault/projects/<project>/backup` (DB backups and small exports)
- `/mnt/vault/projects/<project>/restic` (optional: restic repo target)

## NFS shares (if mounting datasets on a Linux host)

Common pattern:

1) Create the dataset.
2) Create an NFS share for its mount path.
3) Use “Mapall User/Group” when you want a single-user client to write without permission churn.
4) Ensure dataset ACL/mode is compatible with NFS client expectations.

### Middleware API gotcha (SCALE 25.10+)

On some versions, `sharing.nfs.create` expects a single `path` field (not `paths`).

If you see:

- `Field required` for `data.path`
- `Extra inputs are not permitted` for `data.paths`

Use:

```json
{"path":"/mnt/vault/projects/<project>/git-mirror","enabled":true,"ro":false}
```

## ZFS snapshots (NAS-local rollback)

Purpose:

- snapshots give fast local rollback and point-in-time recovery
- offsite backups are a separate layer

TrueNAS UI:

- **Data Protection > Periodic Snapshot Tasks**

Practical starting point:

- hourly snapshots, keep 48
- daily snapshots, keep 30
