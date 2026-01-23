#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

TARGET=""
PROJECT_TITLE=""
PROJECT_ONE_LINE=""
PROJECT_PURPOSE=""
FORCE="0"
DRY_RUN="0"
STRICT="0"

usage() {
  cat <<'EOF'
Bootstrap a repo with the portable ops-standards templates.

Writes (skipping any files that already exist):
  AGENTS.md
  README.md
  CHANGELOG.md
  .vscode/settings.json
  .vscode/extensions.json
  docs/index.md
  docs/current-state.md
  docs/roadmap.md
  docs/active-work.md
  docs/authoring-standards.md
  docs/authoring-standards/index.md
  docs/authoring-standards/core-docs.md
  docs/authoring-standards/changelog.md
  docs/authoring-standards/markdown.md
  docs/authoring-standards/mkdocs.md
  docs/authoring-standards/yaml-tasks.md
  docs/authoring-standards/python.md
  docs/authoring-standards/skills.md
  docs/authoring-standards/vscode.md
  docs/terms.md
  docs/time-standards.md
  docs/vscode-standards.md
  docs/git-hygiene.md
  docs/backup-health.md
  docs/codex.md
  docs/codex-skills-authoring-standards.md
  docs/codex-prompt-authoring-standards.md
  docs/codex-agent-authoring-standards.md
  docs/mcp-standards.md
  docs/secrets-standards.md
  docs/backup-standards.md
  docs/mature-project-patterns.md

Usage:
  scripts/bootstrap.sh --target /path/to/repo \
    --title "My Project" \
    --one-line "One sentence summary" \
    --purpose "Short paragraph purpose"

Safety:
  By default, skips existing files (idempotent).
  Creates the target directory if it does not exist.
  Use --force to overwrite existing files.
  Use --strict to fail if any file exists.
  Use --dry-run to preview.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="${2:-}"; shift 2 ;;
    --title) PROJECT_TITLE="${2:-}"; shift 2 ;;
    --one-line) PROJECT_ONE_LINE="${2:-}"; shift 2 ;;
    --purpose) PROJECT_PURPOSE="${2:-}"; shift 2 ;;
    --force) FORCE="1"; shift ;;
    --dry-run) DRY_RUN="1"; shift ;;
    --strict) STRICT="1"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "${TARGET}" || -z "${PROJECT_TITLE}" || -z "${PROJECT_ONE_LINE}" || -z "${PROJECT_PURPOSE}" ]]; then
  echo "ERROR: --target, --title, --one-line, and --purpose are required" >&2
  exit 2
fi

if [[ ! -d "${TARGET}" ]]; then
  mkdir -p "${TARGET}"
fi

templates="${ROOT}/templates"
if [[ ! -d "${templates}" ]]; then
  echo "ERROR: templates not found: ${templates}" >&2
  exit 2
fi

mkdir -p "${TARGET}/docs" "${TARGET}/.vscode"

escape_sed_replacement() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//&/\\&}"
  value="${value//\//\\/}"
  printf '%s' "${value}"
}

render_into() {
  local src="$1"
  local dst="$2"
  local safe_title
  local safe_one_line
  local safe_purpose

  safe_title="$(escape_sed_replacement "${PROJECT_TITLE}")"
  safe_one_line="$(escape_sed_replacement "${PROJECT_ONE_LINE}")"
  safe_purpose="$(escape_sed_replacement "${PROJECT_PURPOSE}")"

  sed \
    -e "s/{{PROJECT_TITLE}}/${safe_title}/g" \
    -e "s/{{PROJECT_ONE_LINE}}/${safe_one_line}/g" \
    -e "s/{{PROJECT_PURPOSE}}/${safe_purpose}/g" \
    "${src}" > "${dst}"
}

declare -a FILES=(
  "repo-root/AGENTS.md::AGENTS.md"
  "repo-root/README.md::README.md"
  "repo-root/CHANGELOG.md::CHANGELOG.md"
  "repo-root/.vscode/settings.json::.vscode/settings.json"
  "repo-root/.vscode/extensions.json::.vscode/extensions.json"
  "docs/index.md::docs/index.md"
  "docs/current-state.md::docs/current-state.md"
  "docs/roadmap.md::docs/roadmap.md"
  "docs/active-work.md::docs/active-work.md"
  "docs/authoring-standards.md::docs/authoring-standards.md"
  "docs/authoring-standards/index.md::docs/authoring-standards/index.md"
  "docs/authoring-standards/core-docs.md::docs/authoring-standards/core-docs.md"
  "docs/authoring-standards/changelog.md::docs/authoring-standards/changelog.md"
  "docs/authoring-standards/markdown.md::docs/authoring-standards/markdown.md"
  "docs/authoring-standards/mkdocs.md::docs/authoring-standards/mkdocs.md"
  "docs/authoring-standards/yaml-tasks.md::docs/authoring-standards/yaml-tasks.md"
  "docs/authoring-standards/python.md::docs/authoring-standards/python.md"
  "docs/authoring-standards/skills.md::docs/authoring-standards/skills.md"
  "docs/authoring-standards/vscode.md::docs/authoring-standards/vscode.md"
  "docs/terms.md::docs/terms.md"
  "docs/time-standards.md::docs/time-standards.md"
  "docs/vscode-standards.md::docs/vscode-standards.md"
  "docs/git-hygiene.md::docs/git-hygiene.md"
  "docs/backup-health.md::docs/backup-health.md"
  "docs/codex.md::docs/codex.md"
  "docs/codex-skills-authoring-standards.md::docs/codex-skills-authoring-standards.md"
  "docs/codex-prompt-authoring-standards.md::docs/codex-prompt-authoring-standards.md"
  "docs/codex-agent-authoring-standards.md::docs/codex-agent-authoring-standards.md"
  "docs/mcp-standards.md::docs/mcp-standards.md"
  "docs/secrets-standards.md::docs/secrets-standards.md"
  "docs/backup-standards.md::docs/backup-standards.md"
  "docs/mature-project-patterns.md::docs/mature-project-patterns.md"
)

declare -a EXISTS=()
for pair in "${FILES[@]}"; do
  dst_rel="${pair#*::}"
  dst="${TARGET}/${dst_rel}"
  if [[ -e "${dst}" ]]; then
    EXISTS+=("${dst_rel}")
  fi
done

if [[ "${STRICT}" == "1" && "${FORCE}" != "1" && "${#EXISTS[@]}" -gt 0 ]]; then
  echo "ERROR: existing files present (strict mode):" >&2
  printf '  - %s\n' "${EXISTS[@]}" >&2
  echo "Re-run without --strict to skip, or use --force to overwrite." >&2
  exit 2
fi

if [[ "${DRY_RUN}" == "1" ]]; then
  echo "Dry run:" >&2
  for pair in "${FILES[@]}"; do
    dst_rel="${pair#*::}"
    dst="${TARGET}/${dst_rel}"
    if [[ "${FORCE}" == "1" ]]; then
      printf '  - overwrite %s\n' "${dst_rel}" >&2
    elif [[ -e "${dst}" ]]; then
      printf '  - skip      %s\n' "${dst_rel}" >&2
    else
      printf '  - write     %s\n' "${dst_rel}" >&2
    fi
  done
  exit 0
fi

written=0
skipped=0
for pair in "${FILES[@]}"; do
  src_rel="${pair%%::*}"
  dst_rel="${pair#*::}"
  src="${templates}/${src_rel}"
  dst="${TARGET}/${dst_rel}"

  if [[ ! -f "${src}" ]]; then
    echo "ERROR: missing template: ${src_rel}" >&2
    exit 2
  fi

  mkdir -p "$(dirname "${dst}")"

  if [[ "${FORCE}" != "1" && -e "${dst}" ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  render_into "${src}" "${dst}"
  written=$((written + 1))
done

echo "OK: wrote ${written} file(s), skipped ${skipped} existing file(s): ${TARGET}"
