#!/usr/bin/env bash
set -euo pipefail

APPLY=0
PULL=1
STATUS=0
REPORT=""
REPORT_DIR=""
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
  --report <path>   Write a deterministic report to a file
  --report-dir <dir>  Write report to this dir (auto filename)
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
    --report) REPORT="${2:-}"; shift 2 ;;
    --report-dir) REPORT_DIR="${2:-}"; shift 2 ;;
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

report_line() {
  if [[ -n "${REPORT}" ]]; then
    printf '%s\n' "$*" | tee -a "${REPORT}"
  else
    printf '%s\n' "$*"
  fi
}

run_cmd() {
  local cmd=("$@")
  report_line "CMD: ${cmd[*]}"
  if [[ -n "${REPORT}" ]]; then
    "${cmd[@]}" 2>&1 | tee -a "${REPORT}"
  else
    "${cmd[@]}"
  fi
}

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
  if [[ -n "${REPORT_DIR}" && -z "${REPORT}" ]]; then
    REPORT="${REPORT_DIR%/}/seed-live-status-$(date +%Y%m%d%H%M%S).log"
  fi
  if [[ -n "${REPORT}" ]]; then
    mkdir -p "$(dirname "${REPORT}")"
    : > "${REPORT}"
  fi
  report_line "REPORT: seed-live status"
  report_line "TIME: $(date -Is)"
  report_line "Tracking root: ${TRACKING_ROOT}"
  report_line "Live root: ${LIVE_ROOT}"
  report_line "Tracking VERSION: ${tracking_version}"
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
  if [[ -d "${LIVE_ROOT}" ]]; then
    report_line "Live VERSION: ${live_version}"
    report_line "SRD block version (live AGENTS.md): ${srd_block_version}"
  else
    report_line "Live root missing: ${LIVE_ROOT}"
  fi
  exit 0
fi

if [[ "${APPLY}" != "1" ]]; then
  echo "ERROR: --apply is required for seeding." >&2
  exit 2
fi

if [[ -z "${REPORT}" ]]; then
  if [[ -n "${REPORT_DIR}" ]]; then
    REPORT="${REPORT_DIR%/}/seed-live-$(date +%Y%m%d%H%M%S).log"
  else
    REPORT="${LIVE_ROOT%/}/reports/seed-live-$(date +%Y%m%d%H%M%S).log"
  fi
fi

if [[ -n "${REPORT}" ]]; then
  mkdir -p "$(dirname "${REPORT}")"
  : > "${REPORT}"
fi

report_line "REPORT: seed-live apply"
report_line "TIME: $(date -Is)"

if [[ "${PULL}" == "1" ]]; then
  run_cmd git -C "${TRACKING_ROOT}" pull --ff-only
fi

tracking_version="$(cat "${TRACKING_ROOT}/VERSION")"

report_line "Tracking root: ${TRACKING_ROOT}"
report_line "Live root: ${LIVE_ROOT}"
report_line "Tracking VERSION: ${tracking_version}"

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
run_cmd rsync -a "${TRACKING_ROOT}/templates/" "${LIVE_ROOT}/templates/"

run_cmd "${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}"
run_cmd "${TRACKING_ROOT}/scripts/sync-from-upstream.sh" --live "${LIVE_ROOT}" --apply

live_version="$(cat "${LIVE_ROOT}/VERSION")"
if [[ "${live_version}" != "${tracking_version}" ]]; then
  echo "ERROR: VERSION mismatch live=${live_version} tracking=${tracking_version}" >&2
  exit 3
fi

report_line "Seed complete: VERSION ${live_version}"
