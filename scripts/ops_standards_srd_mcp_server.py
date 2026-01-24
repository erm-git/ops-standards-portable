#!/usr/bin/env python3
"""FastMCP server for lightweight knowledgebase retrieval across approved roots.

Default intent: make ops-standards docs readable/searchable by agents working anywhere on CGP.

Env vars:
  OPS_SRD_ROOTS - roots to expose, separated by ":".
                 Each entry is either:
                   - "/abs/path"
                   - "name=/abs/path"
                 Default: "docs=/opt/ops-standards/docs:srd=/opt/ops-standards/srd"
  OPS_KB_ROOTS - legacy alias for OPS_SRD_ROOTS (supported for backwards compatibility).

Security model:
  - Only reads within the configured roots.
  - Only reads a small set of text-like extensions.
  - Enforces a max file size and max excerpt size.
"""

from __future__ import annotations

import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

from fastmcp import FastMCP


DEFAULT_ROOTS = "docs=/opt/ops-standards/docs:srd=/opt/ops-standards/srd"
DEFAULT_LIMIT = 10
MAX_LIMIT = 50
MAX_FILE_BYTES = 2_000_000
MAX_EXCERPT_CHARS = 50_000

ALLOWED_EXTENSIONS = {
    ".md",
    ".txt",
    ".yml",
    ".yaml",
    ".toml",
    ".json",
}

mcp = FastMCP(name="ops_standards_srd", version="0.1.0")

FENCE_RE = re.compile(r"^\s*(```|~~~)")
HEADING_RE = re.compile(r"^(#{1,6})\s+(.+?)\s*$")


@dataclass(frozen=True)
class RootSpec:
    name: str
    path: Path


def _parse_roots(raw: str) -> list[RootSpec]:
    roots: list[RootSpec] = []
    for chunk in (raw or "").split(":"):
        chunk = chunk.strip()
        if not chunk:
            continue

        name: str | None = None
        path_s = chunk
        if "=" in chunk:
            maybe_name, maybe_path = chunk.split("=", 1)
            maybe_name = maybe_name.strip()
            maybe_path = maybe_path.strip()
            if maybe_name and maybe_path:
                name = maybe_name
                path_s = maybe_path

        path = Path(path_s).expanduser().resolve()
        if not path.exists():
            raise RuntimeError(f"KB root does not exist: {path}")
        if not path.is_dir():
            raise RuntimeError(f"KB root must be a directory: {path}")

        if name is None:
            parts = path.parts
            # Prefer a stable, human-ish label like "ops-standards-docs".
            name = "-".join(parts[-2:]) if len(parts) >= 2 else path.name

        roots.append(RootSpec(name=name, path=path))

    if not roots:
        raise RuntimeError("No roots configured (OPS_SRD_ROOTS is empty)")
    return roots


def _roots() -> list[RootSpec]:
    raw = os.getenv("OPS_SRD_ROOTS")
    if raw is None:
        raw = os.getenv("OPS_KB_ROOTS")
    return _parse_roots(raw or DEFAULT_ROOTS)


def _root_by_name(name: str) -> RootSpec:
    name_norm = (name or "").strip()
    if not name_norm:
        raise RuntimeError("root is required")
    for r in _roots():
        if r.name == name_norm:
            return r
    raise RuntimeError(f"unknown root: {name_norm}")


def _safe_path(root: RootSpec, rel_path: str) -> Path:
    rel = (rel_path or "").lstrip("/").strip()
    if not rel:
        raise RuntimeError("path is required")
    candidate = (root.path / rel).resolve()
    if root.path not in candidate.parents and candidate != root.path:
        raise RuntimeError("invalid path (outside root)")
    if not candidate.exists():
        raise RuntimeError(f"not found: {candidate}")
    if candidate.is_dir():
        raise RuntimeError("path is a directory; expected a file")
    if candidate.suffix.lower() not in ALLOWED_EXTENSIONS:
        raise RuntimeError(f"unsupported file extension: {candidate.suffix}")
    if candidate.stat().st_size > MAX_FILE_BYTES:
        raise RuntimeError("file too large for KB read")
    return candidate


def _iter_files(root: RootSpec) -> Iterable[Path]:
    for path in root.path.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix.lower() not in ALLOWED_EXTENSIONS:
            continue
        try:
            if path.stat().st_size > MAX_FILE_BYTES:
                continue
        except OSError:
            continue
        yield path


def _excerpt(text: str, *, max_chars: int) -> str:
    max_chars = max(0, min(int(max_chars), MAX_EXCERPT_CHARS))
    if len(text) <= max_chars:
        return text
    return text[:max_chars]


def _iter_heading_sections(text: str) -> list[dict[str, Any]]:
    lines = text.splitlines(keepends=True)
    in_fence = False
    headings: list[tuple[int, int, str]] = []

    for i, raw in enumerate(lines):
        if FENCE_RE.match(raw):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        m = HEADING_RE.match(raw.rstrip("\n"))
        if not m:
            continue
        level = len(m.group(1))
        heading = m.group(2).strip()
        headings.append((i, level, heading))

    if not headings:
        return [
            {
                "heading": None,
                "level": None,
                "start_char": 0,
                "end_char": len(text),
            }
        ]

    line_starts: list[int] = []
    pos = 0
    for raw in lines:
        line_starts.append(pos)
        pos += len(raw)

    sections: list[dict[str, Any]] = []
    for idx, (line_i, level, heading) in enumerate(headings):
        next_line_i = headings[idx + 1][0] if idx + 1 < len(headings) else len(lines)
        start_char = line_starts[line_i] if line_i < len(line_starts) else 0
        end_char = line_starts[next_line_i] if next_line_i < len(line_starts) else len(text)
        sections.append(
            {
                "heading": heading,
                "level": level,
                "start_char": start_char,
                "end_char": end_char,
            }
        )
    return sections


def _section_for_pos(sections: list[dict[str, Any]], pos: int) -> dict[str, Any]:
    for s in sections:
        if int(s["start_char"]) <= pos < int(s["end_char"]):
            return s
    return sections[0]


def _find_first_pos(text: str, query: str) -> int:
    q = (query or "").strip().lower()
    if not q:
        return -1
    return text.lower().find(q)


def _snippet(text: str, pos: int, query: str, *, context_chars: int) -> str:
    q = (query or "").strip()
    if pos < 0 or not q:
        return ""
    start = max(0, pos - context_chars)
    end = min(len(text), pos + len(q) + context_chars)
    return text[start:end].strip()


@mcp.tool()
async def list_roots() -> dict[str, Any]:
    """List configured KB roots."""

    return {
        "roots": [{"name": r.name, "path": str(r.path)} for r in _roots()],
        "allowed_extensions": sorted(ALLOWED_EXTENSIONS),
        "max_file_bytes": MAX_FILE_BYTES,
    }


@mcp.tool()
async def list_files(root: str, limit: int = 200) -> dict[str, Any]:
    """List eligible text files under a root (relative paths)."""

    r = _root_by_name(root)
    limit = max(0, min(int(limit), 5000))
    files = []
    for path in sorted(_iter_files(r)):
        rel = path.relative_to(r.path)
        files.append(str(rel))
        if len(files) >= limit:
            break
    return {"root": r.name, "count": len(files), "files": files}


@mcp.tool()
async def read_doc(root: str, path: str, max_chars: int = 20_000) -> dict[str, Any]:
    """Read a doc file under a root (safe path + size guards)."""

    r = _root_by_name(root)
    p = _safe_path(r, path)
    text = p.read_text(encoding="utf-8", errors="replace")
    return {"root": r.name, "path": str(path), "text": _excerpt(text, max_chars=max_chars)}


@mcp.tool()
async def search_docs(
    query: str,
    root: str | None = None,
    limit: int = DEFAULT_LIMIT,
    context_chars: int = 180,
) -> dict[str, Any]:
    """Substring search over eligible docs, returning small, heading-scoped snippets."""

    query_norm = (query or "").strip()
    if not query_norm:
        return {"query": query, "count": 0, "results": []}

    limit = max(0, min(int(limit), MAX_LIMIT))
    context_chars = max(0, min(int(context_chars), 400))

    roots = [_root_by_name(root)] if root else _roots()
    results: list[dict[str, Any]] = []

    for r in roots:
        for path in _iter_files(r):
            try:
                text = path.read_text(encoding="utf-8", errors="replace")
            except Exception:
                continue
            pos = _find_first_pos(text, query_norm)
            if pos < 0:
                continue
            sections = _iter_heading_sections(text) if path.suffix.lower() == ".md" else None
            heading = None
            level = None
            if sections:
                sec = _section_for_pos(sections, pos)
                heading = sec.get("heading")
                level = sec.get("level")
            snippet = _snippet(text, pos, query_norm, context_chars=context_chars)
            results.append(
                {
                    "root": r.name,
                    "path": str(path.relative_to(r.path)),
                    "heading": heading,
                    "level": level,
                    "snippet": snippet,
                }
            )
            if len(results) >= limit:
                return {"query": query, "count": len(results), "results": results}

    return {"query": query, "count": len(results), "results": results}


if __name__ == "__main__":
    mcp.run()
