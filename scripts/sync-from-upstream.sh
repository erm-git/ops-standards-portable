#!/usr/bin/env bash
set -euo pipefail

APPLY=0
REPORT=""
LIVE_ROOT=""
TRACKING_ROOT=""

usage() {
  cat <<'USAGE'
Sync portable content (srd/, templates/, VERSION) from tracking clone to live copy.

Usage:
  scripts/sync-from-upstream.sh --live /opt/ops-standards
  scripts/sync-from-upstream.sh --live /opt/ops-standards --apply

Options:
  --live <path>     Live copy root (required)
  --tracking <path> Tracking clone root (defaults to this repo root)
  --apply           Write changes (default is dry-run)
  --report <path>   Write output to a file (in addition to stdout)
  -h, --help        Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --live) LIVE_ROOT="${2:-}"; shift 2 ;;
    --tracking) TRACKING_ROOT="${2:-}"; shift 2 ;;
    --report) REPORT="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TRACKING_ROOT="${TRACKING_ROOT:-$ROOT}"

if [[ -z "${LIVE_ROOT}" ]]; then
  echo "ERROR: --live <path> is required (example: --live /opt/ops-standards)" >&2
  exit 2
fi

if [[ ! -d "${TRACKING_ROOT}/srd" || ! -d "${TRACKING_ROOT}/templates" || ! -f "${TRACKING_ROOT}/VERSION" ]]; then
  echo "ERROR: tracking root missing required paths: ${TRACKING_ROOT}" >&2
  exit 2
fi

if [[ ! -d "${LIVE_ROOT}" ]]; then
  echo "ERROR: live root not found: ${LIVE_ROOT}" >&2
  exit 2
fi

rsync_args=(-a --delete --itemize-changes)
if [[ "${APPLY}" != "1" ]]; then
  rsync_args+=(--dry-run)
fi

run_cmd() {
  if [[ -n "${REPORT}" ]]; then
    "$@" | tee -a "${REPORT}"
  else
    "$@"
  fi
}

if [[ -n "${REPORT}" ]]; then
  : > "${REPORT}"
fi

echo "Tracking root: ${TRACKING_ROOT}"
echo "Live root: ${LIVE_ROOT}"
echo "Mode: $([[ "${APPLY}" == "1" ]] && echo apply || echo dry-run)"

run_cmd rsync "${rsync_args[@]}" "${TRACKING_ROOT}/srd/" "${LIVE_ROOT}/srd/"
run_cmd rsync "${rsync_args[@]}" "${TRACKING_ROOT}/templates/" "${LIVE_ROOT}/templates/"

if [[ "${APPLY}" == "1" ]]; then
  run_cmd cp "${TRACKING_ROOT}/VERSION" "${LIVE_ROOT}/VERSION"
else
  if cmp -s "${TRACKING_ROOT}/VERSION" "${LIVE_ROOT}/VERSION"; then
    run_cmd echo "VERSION: no change"
  else
    run_cmd echo "VERSION: would update ${LIVE_ROOT}/VERSION"
  fi
fi
