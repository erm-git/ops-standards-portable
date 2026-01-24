---
title: "Agent Workflow Templates (Portable SRD)"
status: "standard"
---

## Purpose

Define three supported agent styles and the exact files each requires.

## 1) Codex‑only

Required:

- `AGENTS.md` (single source of agent instructions)
- `README.md` (quick start + workflow notes)

Optional:

- `docs/` standard set as needed (`docs/index.md`, `docs/current-state.md`, `docs/roadmap.md`, `docs/active-work.md`)

Codex references:

- Codex docs: `https://developers.openai.com/codex/`  
- `AGENTS.md` guidance: `https://developers.openai.com/codex/guides/agents-md`  
- Codex config reference: `https://developers.openai.com/codex/config-reference`  
- Codex skills: `https://developers.openai.com/codex/skills`  
- Codex GitHub repo: `https://github.com/openai/codex`

## 2) Copilot‑only

Required:

- `.github/copilot-instructions.md` (single source of agent instructions)
- `README.md`

Optional:

- `docs/` standard set as needed

## 3) Codex + Copilot (hybrid)

Required:

- `AGENTS.md` (Codex)
- `.github/copilot-instructions.md` (Copilot)
- `README.md`

Rules:

- Keep scopes distinct (Codex instructions in `AGENTS.md`, Copilot instructions in `.github/copilot-instructions.md`).
- Avoid conflicting directives between the two files.
