#!/usr/bin/env bash
set -euo pipefail

APPLY=0
PULL=1
STATUS=0
LIVE_ROOT="/opt/ops-standards"
TRACKING_ROOT=""
TITLE="Ops Standards (Local)"
ONE_LINE="Local standards and references for this host"
PURPOSE="Local standards repo seeded from portable baseline, with host-specific additions."

usage() {
  cat <<'USAGE'
Seed a live ops-standards copy from the portable tracking clone.

Usage:
  scripts/seed-live.sh --apply
  scripts/seed-live.sh --apply --no-pull
  scripts/seed-live.sh --live /opt/ops-standards --tracking /srv/dev/ops-standards-portable --apply
  scripts/seed-live.sh --status

Options:
  --apply           Perform writes (required)
  --no-pull         Skip git pull in tracking clone before seeding
  --status          Read-only status (no writes, no pull)
  --live <path>     Live root (default: /opt/ops-standards)
  --tracking <path> Tracking clone root (default: this repo root)
  --title <text>    README title (default: Ops Standards (Local))
  --one-line <text> README one-line (default: Local standards and references for this host)
  --purpose <text>  README purpose (default: Local standards repo seeded from portable baseline, with host-specific additions.)
  -h, --help        Show help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --no-pull) PULL=0; shift ;;
    --status) STATUS=1; shift ;;
    --live) LIVE_ROOT="${2:-}"; shift 2 ;;
    --tracking) TRACKING_ROOT="${2:-}"; shift 2 ;;
    --title) TITLE="${2:-}"; shift 2 ;;
    --one-line) ONE_LINE="${2:-}"; shift 2 ;;
    --purpose) PURPOSE="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TRACKING_ROOT="${TRACKING_ROOT:-$ROOT}"

if [[ ! -d "${TRACKING_ROOT}/.git" ]]; then
  echo "ERROR: tracking clone not found: ${TRACKING_ROOT}" >&2
  exit 2
fi

if [[ ! -d "${TRACKING_ROOT}/templates" || ! -f "${TRACKING_ROOT}/VERSION" ]]; then
  echo "ERROR: tracking clone missing required paths: ${TRACKING_ROOT}" >&2
  exit 2
fi

tracking_version="(missing)"
if [[ -f "${TRACKING_ROOT}/VERSION" ]]; then
  tracking_version="$(cat "${TRACKING_ROOT}/VERSION")"
fi

if [[ "${STATUS}" == "1" ]]; then
  live_version="(missing)"
  srd_block_version="(missing)"
  if [[ -f "${LIVE_ROOT}/VERSION" ]]; then
    live_version="$(cat "${LIVE_ROOT}/VERSION")"
  fi
  if [[ -f "${LIVE_ROOT}/AGENTS.md" ]]; then
    srd_block_version="$(sed -n 's/^-[[:space:]]*SRD block version:[[:space:]]*`\(.*\)`$/\1/p' "${LIVE_ROOT}/AGENTS.md" | head -n 1)"
    if [[ -z "${srd_block_version}" ]]; then
      srd_block_version="(missing)"
    fi
  fi
  echo "Tracking root: ${TRACKING_ROOT}"
  echo "Tracking VERSION: ${tracking_version}"
  echo "Live root: ${LIVE_ROOT}"
  if [[ -d "${LIVE_ROOT}" ]]; then
    echo "Live VERSION: ${live_version}"
    echo "SRD block version (live AGENTS.md): ${srd_block_version}"
  else
    echo "Live root missing: ${LIVE_ROOT}"
  fi
  exit 0
fi

if [[ "${APPLY}" != "1" ]]; then
  echo "ERROR: --apply is required for seeding." >&2
  exit 2
fi

if [[ "${PULL}" == "1" ]]; then
  git -C "${TRACKING_ROOT}" pull --ff-only
fi

tracking_version="$(cat "${TRACKING_ROOT}/VERSION")"

echo "Tracking root: ${TRACKING_ROOT}"
echo "Live root: ${LIVE_ROOT}"
echo "Tracking VERSION: ${tracking_version}"

if [[ ! -d "${LIVE_ROOT}" ]]; then
  echo "ERROR: live root not found: ${LIVE_ROOT}" >&2
  echo "Create it once, then re-run:" >&2
  echo "  sudo mkdir -p \"${LIVE_ROOT}\"" >&2
  echo "  sudo chown \"$USER:$USER\" \"${LIVE_ROOT}\"" >&2
  exit 3
fi

if [[ ! -w "${LIVE_ROOT}" ]]; then
  echo "ERROR: live root not writable: ${LIVE_ROOT}" >&2
  echo "Fix ownership, then re-run:" >&2
  echo "  sudo chown \"$USER:$USER\" \"${LIVE_ROOT}\"" >&2
  exit 3
fi

"${TRACKING_ROOT}/scripts/bootstrap.sh" \
  --target "${LIVE_ROOT}" \
  --title "${TITLE}" \
  --one-line "${ONE_LINE}" \
  --purpose "${PURPOSE}"

mkdir -p "${LIVE_ROOT}/templates"
rsync -a "${TRACKING_ROOT}/templates/" "${LIVE_ROOT}/templates/"

"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}"
"${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}" --apply

live_version="$(cat "${LIVE_ROOT}/VERSION")"
if [[ "${live_version}" != "${tracking_version}" ]]; then
  echo "ERROR: VERSION mismatch live=${live_version} tracking=${tracking_version}" >&2
  exit 3
fi

echo "Seed complete: VERSION ${live_version}"
