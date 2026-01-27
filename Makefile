.PHONY: sync-from-upstream sync-from-upstream-apply

sync-from-upstream:
\t@ : $${LIVE_ROOT:?"Set LIVE_ROOT=/opt/ops-standards"}
\t@ scripts/sync-from-upstream.sh --live "$${LIVE_ROOT}"

sync-from-upstream-apply:
\t@ : $${LIVE_ROOT:?"Set LIVE_ROOT=/opt/ops-standards"}
\t@ scripts/sync-from-upstream.sh --live "$${LIVE_ROOT}" --apply
