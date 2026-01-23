---
title: "Authoring Standards (CGP SRD)"
status: "standard"
---

## Purpose

These standards define how CGP project repos should be structured, documented, and maintained.

This content is intended to be retrieved via MCP (`ops_standards_srd`) by agents working in *other* repos, so those repos can conform to the SRD without copying docs into each repo.

## Start here

- Core docs contract: `srd/authoring-standards/core-docs.md`
- Changelog rules: `srd/authoring-standards/changelog.md`
- Markdown rules: `srd/authoring-standards/markdown.md`
- MkDocs rules: `srd/authoring-standards/mkdocs.md`
- YAML tasks rules: `srd/authoring-standards/yaml-tasks.md`
- Python defaults: `srd/authoring-standards/python.md`
- Skills (SKILL.md) authoring: `srd/authoring-standards/skills.md`
- VS Code practices: `srd/authoring-standards/vscode.md`
- Agent workflow templates: `srd/authoring-standards/agent-workflows.md`

## Pointer vs local copy (rule)

Use a **pointer file** when a doc is system‑wide canonical and should not be customized.

Use a **local copy** when a repo must customize/extend the doc, or the doc is repo‑specific.

Use **seed + customize** when a repo needs the standard structure but must own the content (for example `AGENTS.md`, `docs/backups.md`).
