#!/usr/bin/env bash
set -euo pipefail

APPLY=0
PULL=0
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
  scripts/seed-live.sh --apply --pull
  scripts/seed-live.sh --live /opt/ops-standards --tracking /srv/dev/ops-standards-portable --apply

Options:
  --apply           Perform writes (required)
  --pull            git pull --ff-only in tracking clone before seeding
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
    --pull) PULL=1; shift ;;
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

if [[ "${APPLY}" != "1" ]]; then
  echo "ERROR: --apply is required for seeding." >&2
  exit 2
fi

if [[ ! -d "${TRACKING_ROOT}/.git" ]]; then
  echo "ERROR: tracking clone not found: ${TRACKING_ROOT}" >&2
  exit 2
fi

if [[ ! -d "${TRACKING_ROOT}/templates" || ! -f "${TRACKING_ROOT}/VERSION" ]]; then
  echo "ERROR: tracking clone missing required paths: ${TRACKING_ROOT}" >&2
  exit 2
fi

if [[ "${PULL}" == "1" ]]; then
  git -C "${TRACKING_ROOT}" pull --ff-only
fi

tracking_version="$(cat "${TRACKING_ROOT}/VERSION")"

echo "Tracking root: ${TRACKING_ROOT}"
echo "Live root: ${LIVE_ROOT}"
echo "Tracking VERSION: ${tracking_version}"

sudo mkdir -p "${LIVE_ROOT}"
sudo chown "$USER":"$USER" "${LIVE_ROOT}"

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
