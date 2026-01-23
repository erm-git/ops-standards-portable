---
title: "Python Projects (CGP SRD)"
status: "standard"
---

## Default template (modern)

Use this when you are starting a modern Python library/CLI/service repo on CGP.

Baseline structure:

- `pyproject.toml` (PEP 621)
- `src/<pkg>/...` (preferred)
- `tests/...`
- `scripts/` (optional; deterministic helpers)
- `.venv/` (local-only; gitignored)
- `README.md` (quick start + common commands)

Tooling (recommended):

- `uv` for virtualenv + dependency management (prefer committing `uv.lock` when used)
- `ruff` for formatting + linting
- `pytest` for tests
- optional: `pyright` (or `mypy`) for type checking

Repo hygiene:

- Keep `scripts/` non-interactive by default; accept flags/env vars instead

## `uv` conventions

- Prefer `uv` as the single entrypoint for env + deps.
- Commit `uv.lock` when the repo is meant to be reproducible.
- Prefer `pyproject.toml` as the source of truth (avoid duplicated deps in `requirements.txt` unless required for legacy tooling).

## Ruff conventions

- Use ruff for both formatting and linting.
- Keep configuration in `pyproject.toml`.

## Testing conventions

- Tests run via `pytest`.
- Keep the default path layout compatible with `pytest` discovery (`tests/`).
