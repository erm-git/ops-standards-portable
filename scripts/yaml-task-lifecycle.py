#!/usr/bin/env python3
"""
YAML task lifecycle helper (CCP-aligned).

Moves YAML tasks between todo/ -> in-progress/ -> done/ and updates the
YAML header `status:` field. Uses git mv when possible.

Usage:
  python3 scripts/yaml-task-lifecycle.py start <path/to/yaml>
  python3 scripts/yaml-task-lifecycle.py finish <path/to/yaml>
"""
from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
YAML_ROOT = REPO_ROOT / "yaml-tasks"
FOLDERS = ("todo", "in-progress", "done", "backlog")
STOP_RE = re.compile(r"(?m)^(intent|task)\s*:\s*(\||>).*?$")
STATUS_RE = re.compile(r"(?m)^(status\s*:\s*)(.+?)\s*$")
COMPLETION_RE = re.compile(r"(?m)^completion\s*:")


def die(msg: str, code: int = 1) -> None:
    print(f"ERROR: {msg}", file=sys.stderr)
    sys.exit(code)


def run_git(args: list[str], cwd: Path, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(["git", *args], cwd=cwd, check=check, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


def is_git_repo(cwd: Path) -> bool:
    try:
        run_git(["rev-parse", "--is-inside-work-tree"], cwd)
        return True
    except subprocess.CalledProcessError:
        return False


def is_tracked(relpath: str, cwd: Path) -> bool:
    try:
        run_git(["ls-files", "--error-unmatch", relpath], cwd)
        return True
    except subprocess.CalledProcessError:
        return False


def run_git_mv(src: Path, dest: Path) -> bool:
    rel_src = src.relative_to(REPO_ROOT)
    rel_dest = dest.relative_to(REPO_ROOT)
    try:
        run_git(["mv", str(rel_src), str(rel_dest)], REPO_ROOT)
        return True
    except subprocess.CalledProcessError:
        return False


def split_header_body(text: str) -> tuple[str, str]:
    m = STOP_RE.search(text)
    if not m:
        return text, ""
    return text[: m.start()], text[m.start() :]


def update_status(path: Path, new_status: str) -> None:
    text = path.read_text(encoding="utf-8")
    header, body = split_header_body(text)
    m = STATUS_RE.search(header)
    if m:
        new_header = STATUS_RE.sub(f"\\g<1>{new_status}", header, count=1)
    else:
        lines = header.splitlines()
        insert_at = 0
        for i, line in enumerate(lines[:40]):
            if re.match(r"^[A-Za-z0-9_-]+\s*:", line):
                insert_at = i + 1
                continue
            break
        lines.insert(insert_at, f"status: {new_status}")
        new_header = "\n".join(lines)
    path.write_text(new_header + body, encoding="utf-8", newline="\n")


def ensure_completion_block(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    if not COMPLETION_RE.search(text):
        die(f"finish refused: missing required completion: block in {path}")


def resolve_paths(arg_path: str) -> tuple[Path, str, str]:
    p = Path(arg_path)
    if not p.is_absolute():
        p = (REPO_ROOT / p).resolve()
    if not p.exists():
        die(f"file not found: {p}")
    parts = p.parts
    folder = next((f for f in FOLDERS if f in parts), None)
    if not folder:
        die(f"YAML must live under one of {FOLDERS}: {p}")
    return p, folder, p.name


def target_for(action: str, current_folder: str, filename: str) -> tuple[Path, str]:
    if action == "start":
        if current_folder != "todo":
            die(f"start expects file in todo/, got {current_folder}")
        dest_folder = "in-progress"
    elif action == "finish":
        if current_folder != "in-progress":
            die(f"finish expects file in in-progress/, got {current_folder}")
        dest_folder = "done"
    else:
        die(f"unknown action {action}")
    return YAML_ROOT / dest_folder / filename, dest_folder


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("action", choices=("start", "finish"))
    ap.add_argument("path", help="Path to YAML (relative or absolute)")
    args = ap.parse_args()

    src, folder, filename = resolve_paths(args.path)
    dest, dest_folder = target_for(args.action, folder, filename)
    dest.parent.mkdir(parents=True, exist_ok=True)

    if args.action == "finish":
        ensure_completion_block(src)

    moved = run_git_mv(src, dest) if is_git_repo(REPO_ROOT) and is_tracked(src.relative_to(REPO_ROOT).as_posix(), REPO_ROOT) else False
    if not moved:
        shutil.move(src, dest)

    update_status(dest, dest_folder)
    print(f"{args.action}: {src} -> {dest} (status set to {dest_folder})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
