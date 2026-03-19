#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Ensure AQUA_GLOBAL_CONFIG is set in env for Codex STDIO MCP servers (see `codex mcp list --json`).

Uses `codex mcp remove` + `codex mcp add` because the CLI has no partial env update. Options that
`mcp add` does not set (cwd, env_vars, timeouts, tool allowlists, etc.) may reset to defaults.
"""

from __future__ import annotations

import json
import os
import subprocess
from typing import Any

from ansible.module_utils.basic import AnsibleModule


def _run_codex(args: list[str], module: AnsibleModule) -> str:
    try:
        proc = subprocess.run(
            ["codex", *args],
            capture_output=True,
            text=True,
            check=False,
        )
    except FileNotFoundError:
        module.fail_json(msg="codex CLI not found in PATH")
    if proc.returncode != 0:
        module.fail_json(
            msg="codex command failed",
            args=args,
            stdout=proc.stdout,
            stderr=proc.stderr,
            rc=proc.returncode,
        )
    return proc.stdout


def _load_mcp_list(module: AnsibleModule) -> list[dict[str, Any]]:
    out = _run_codex(["mcp", "list", "--json"], module).strip()
    if not out:
        return []
    try:
        data = json.loads(out)
    except json.JSONDecodeError as e:
        module.fail_json(
            msg="failed to parse codex mcp list --json output",
            detail=str(e),
            raw=out[:500],
        )
    if not isinstance(data, list):
        module.fail_json(
            msg="unexpected JSON shape from codex mcp list --json (expected array)",
            raw=out[:500],
        )
    return data


def _get_server(module: AnsibleModule, name: str) -> dict[str, Any]:
    out = _run_codex(["mcp", "get", name, "--json"], module).strip()
    try:
        return json.loads(out)
    except json.JSONDecodeError as e:
        module.fail_json(
            msg=f"failed to parse codex mcp get {name} --json output",
            detail=str(e),
            raw=out[:500],
        )


def _needs_aqua_env(entry: dict[str, Any]) -> bool:
    transport = entry.get("transport") or {}
    if transport.get("type") != "stdio":
        return False
    env = transport.get("env") or {}
    val = env.get("AQUA_GLOBAL_CONFIG")
    return not val


def _readd_stdio_server(
    module: AnsibleModule,
    name: str,
    aqua_path: str,
    check_mode: bool,
) -> bool:
    detail = _get_server(module, name)
    transport = detail.get("transport") or {}
    if transport.get("type") != "stdio":
        return False
    command = transport.get("command")
    if not command:
        module.fail_json(msg=f"STDIO MCP server {name!r} has no command")
    args = transport.get("args") or []
    merged_env: dict[str, str] = dict(transport.get("env") or {})
    merged_env["AQUA_GLOBAL_CONFIG"] = aqua_path

    if check_mode:
        return True

    _run_codex(["mcp", "remove", name], module)

    add_cmd = ["codex", "mcp", "add", name]
    for k in sorted(merged_env.keys()):
        add_cmd.extend(["--env", f"{k}={merged_env[k]}"])
    add_cmd.append("--")
    add_cmd.append(command)
    add_cmd.extend(str(a) for a in args)

    try:
        proc = subprocess.run(add_cmd, capture_output=True, text=True, check=False)
    except FileNotFoundError:
        module.fail_json(msg="codex CLI not found in PATH while re-adding MCP server")
    if proc.returncode != 0:
        module.fail_json(
            msg=f"failed to re-add MCP server {name!r} (remove already applied)",
            command=add_cmd,
            stdout=proc.stdout,
            stderr=proc.stderr,
            rc=proc.returncode,
        )
    return True


def main() -> None:
    module = AnsibleModule(
        argument_spec=dict(
            aqua_global_config=dict(type="path", required=False, default=None),
        ),
        supports_check_mode=True,
    )

    raw_path = module.params["aqua_global_config"]
    if raw_path:
        aqua_path = os.path.abspath(os.path.expanduser(str(raw_path)))
    else:
        aqua_path = os.path.abspath(
            os.path.expanduser("~/.config/aquaproj-aqua/aqua.yaml")
        )

    entries = _load_mcp_list(module)
    to_fix = [e for e in entries if _needs_aqua_env(e)]

    if not to_fix:
        module.exit_json(
            changed=False,
            msg="all STDIO MCP servers already have AQUA_GLOBAL_CONFIG set",
        )

    updated: list[str] = []
    check_mode = module.check_mode

    for entry in to_fix:
        name = entry.get("name")
        if not name:
            continue
        if _readd_stdio_server(module, name, aqua_path, check_mode):
            updated.append(name)

    module.exit_json(
        changed=bool(updated),
        msg=(
            f"set AQUA_GLOBAL_CONFIG on STDIO MCP servers: {', '.join(updated)}"
            if updated
            else "no changes"
        ),
        updated_servers=updated,
        aqua_global_config=aqua_path,
    )


if __name__ == "__main__":
    main()
