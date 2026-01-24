---
title: "Python Projects (Portable SRD)"
status: "standard"
---

## Default template (modern)

Use this when you are starting a modern Python library/CLI/service repo.

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
- `pyright` (preferred) or `mypy` for type checking

Repo hygiene:

- Keep `scripts/` non-interactive by default; accept flags/env vars instead
- Gitignore local-only artifacts (`.venv/`, caches, build outputs)

## `uv` conventions

- Prefer `uv` as the single entrypoint for env + deps.
- Commit `uv.lock` when the repo is meant to be reproducible.
- Prefer `pyproject.toml` as the source of truth (avoid duplicated deps in `requirements.txt` unless required for legacy tooling).

Recommended commands:

- Create venv: `uv venv`
- Install/sync deps: `uv sync`
- Run tools: `uv run <tool>` (keeps tool execution inside the managed env)

## Ruff conventions

- Use ruff for both formatting and linting.
- Keep configuration in `pyproject.toml`.
- Standard commands:
  - `uv run ruff format .`
  - `uv run ruff check .`

Minimal config (example):

```toml
[tool.ruff]
target-version = "py311"
line-length = 100

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM", "PIE"]
```

## Testing conventions

- Tests run via `pytest`.
- Keep the default path layout compatible with `pytest` discovery (`tests/`).
- Standard command: `uv run pytest`

Minimal config (example):

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-q"
```

## Typing conventions

- Prefer `pyright` for fast, strict type checks.
- Use `mypy` only when required by the project.
- Standard command:
  - `uv run pyright` or `uv run mypy`

Minimal pyright config (example):

```toml
[tool.pyright]
typeCheckingMode = "standard"
```

## Make targets (optional but recommended)

- `make fmt` → `uv run ruff format .`
- `make lint` → `uv run ruff check .`
- `make test` → `uv run pytest`
- `make type` → `uv run pyright` (or `mypy`)
