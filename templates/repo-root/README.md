# {{PROJECT_TITLE}}

{{PROJECT_ONE_LINE}}

## Start here

- `AGENTS.md`
- `docs/index.md`
- `docs/current-state.md`
- `docs/roadmap.md`

## Build/Run (if applicable)

TODO: add commands relevant to this repo.

## Permissions (Linux/WSL)

When you create directories with `sudo` (e.g., under `/opt`, `/srv`, `/var/opt`), they may end up owned by `root:root` and block normal work.

Fix ownership to your login user (UID/GID varies by host):

```bash
sudo chown -R "$USER:$USER" /opt/<thing>
sudo chown -R "$USER:$USER" /srv/<thing>
sudo chown -R "$USER:$USER" /var/opt/<thing>
```

If you’re unsure what’s root-owned:

```bash
sudo find /opt /srv /var/opt -maxdepth 4 -user root -type d -print
```
