#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path

if sys.version_info < (3, 11):
    raise SystemExit("Python 3.11+ required (tomllib)")

import tomllib


@dataclass(frozen=True)
class NameMap:
    codex: str
    vscode: str


SPECIAL_NAME_MAPS = (
    NameMap(codex="github-mcp-server", vscode="io.github.github/github-mcp-server"),
    NameMap(codex="hf-mcp-server", vscode="huggingface/hf-mcp-server"),
)


def _now_stamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def _load_codex_config(path: Path) -> dict:
    data = tomllib.loads(path.read_text(encoding="utf-8"))
    return data


def _server_to_vscode_entry(server: dict) -> dict:
    if "command" in server:
        entry: dict = {
            "type": "stdio",
            "command": server["command"],
            "args": server.get("args", []),
        }
        if "cwd" in server:
            entry["cwd"] = server["cwd"]
        env = server.get("env", {})
        if env:
            entry["env"] = env
        return entry

    if "url" in server:
        entry = {
            "type": "http",
            "url": server["url"],
        }
        headers: dict[str, str] = {}

        bearer_env = server.get("bearer_token_env_var")
        if bearer_env:
            headers["Authorization"] = f"Bearer ${{env:{bearer_env}}}"

        env_http_headers = server.get("env_http_headers", {})
        for header_name, env_var in env_http_headers.items():
            headers[header_name] = f"${{env:{env_var}}}"

        static_http_headers = server.get("static_http_headers", {})
        for header_name, value in static_http_headers.items():
            headers[header_name] = value

        if headers:
            entry["headers"] = headers
        return entry

    raise ValueError("Unknown MCP server shape: expected command or url")


def _merge_preserving_unknown(existing: dict, updated: dict) -> dict:
    merged = dict(existing)
    merged.update(updated)
    return merged


def _apply_special_name_map(codex_name: str, existing_servers: dict) -> str:
    for m in SPECIAL_NAME_MAPS:
        if m.codex == codex_name and m.vscode in existing_servers:
            return m.vscode
    return codex_name


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Sync VS Code Remote MCP config (mcp.json) from Codex config.toml mcp_servers."
    )
    parser.add_argument(
        "--codex-config",
        default=str(Path.home() / ".codex" / "config.toml"),
        help="Path to ~/.codex/config.toml",
    )
    parser.add_argument(
        "--vscode-mcp-json",
        default=str(Path.home() / ".vscode-server" / "data" / "User" / "mcp.json"),
        help="Path to VS Code Remote User mcp.json",
    )
    parser.add_argument(
        "--write",
        action="store_true",
        help="Write changes (default is dry-run to stdout).",
    )
    args = parser.parse_args()

    codex_config_path = Path(args.codex_config).expanduser()
    vscode_mcp_path = Path(args.vscode_mcp_json).expanduser()

    codex_config = _load_codex_config(codex_config_path)
    codex_servers = codex_config.get("mcp_servers", {})

    if not isinstance(codex_servers, dict) or not codex_servers:
        raise SystemExit(f"No [mcp_servers.*] entries found in {codex_config_path}")

    existing_doc: dict = {}
    if vscode_mcp_path.exists():
        existing_doc = json.loads(vscode_mcp_path.read_text(encoding="utf-8"))

    existing_servers = existing_doc.get("servers", {})
    if not isinstance(existing_servers, dict):
        existing_servers = {}

    next_servers: dict[str, dict] = dict(existing_servers)

    for codex_name, server in sorted(codex_servers.items()):
        if not isinstance(server, dict):
            continue

        vscode_name = _apply_special_name_map(codex_name, existing_servers)
        updated_entry = _server_to_vscode_entry(server)

        if vscode_name in next_servers and isinstance(next_servers[vscode_name], dict):
            next_servers[vscode_name] = _merge_preserving_unknown(
                next_servers[vscode_name], updated_entry
            )
        else:
            next_servers[vscode_name] = updated_entry

    out_doc = {"servers": next_servers}
    out_text = json.dumps(out_doc, indent=2, sort_keys=True) + "\n"

    if not args.write:
        sys.stdout.write(out_text)
        return 0

    vscode_mcp_path.parent.mkdir(parents=True, exist_ok=True)
    if vscode_mcp_path.exists():
        backup_path = vscode_mcp_path.with_suffix(
            vscode_mcp_path.suffix + f".bak-{_now_stamp()}"
        )
        shutil.copy2(vscode_mcp_path, backup_path)

    vscode_mcp_path.write_text(out_text, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

