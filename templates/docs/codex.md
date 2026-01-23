---
title: "Codex (Agenting)"
status: "standard"
---

## Project instructions: `AGENTS.md`

Codex can load extra instructions from `AGENTS.md` and merges them top-down:

1. `~/.codex/AGENTS.md`
2. `AGENTS.md` at repo root
3. `AGENTS.md` in the current working directory

Disable loading of project docs with `--no-project-doc` or `CODEX_DISABLE_PROJECT_DOC=1`.

Reference: `https://developers.openai.com/codex/guides/agents-md`

## Skills

- Skills install into `$CODEX_HOME/skills` (defaults to `~/.codex/skills`)
- Keep skill `SKILL.md` lean; put large references in `references/`

Reference: `https://developers.openai.com/codex/skills`
