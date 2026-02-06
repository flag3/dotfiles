#!/usr/bin/python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function

__metaclass__ = type

from ansible.module_utils.basic import AnsibleModule
import shutil


def _parse_name_and_version(name: str):
    """
    Accept:
      - publisher.ext
      - publisher.ext@1.2.3
    """
    if "@" in name:
        base, ver = name.split("@", 1)
        base = base.strip()
        ver = ver.strip()
        return base, ver
    return name.strip(), None


def _build_base_args(module, cursor_cmd):
    args = [cursor_cmd]
    user_data_dir = module.params.get("user_data_dir")
    extensions_dir = module.params.get("extensions_dir")
    if user_data_dir:
        args += ["--user-data-dir", user_data_dir]
    if extensions_dir:
        args += ["--extensions-dir", extensions_dir]
    return args


def _run(module, args):
    rc, out, err = module.run_command(args)
    return rc, out, err


def _list_extensions(module, cursor_cmd):
    """
    Prefer versions if supported:
      cursor --list-extensions --show-versions
    Fallback to:
      cursor --list-extensions
    Returns:
      installed_map: { "publisher.ext": "1.2.3" or None }
      raw_list: list[str] (lines)
    """
    base = _build_base_args(module, cursor_cmd)

    # Try with versions
    rc, out, err = _run(module, base + ["--list-extensions", "--show-versions"])
    if rc == 0:
        lines = [line.strip() for line in out.splitlines() if line.strip()]
        installed = {}
        # expected lines like: publisher.ext@1.2.3
        for line in lines:
            if "@" in line:
                n, v = line.split("@", 1)
                installed[n.strip()] = v.strip()
            else:
                installed[line] = None
        return installed, lines, out, err

    # Fallback without versions
    rc2, out2, err2 = _run(module, base + ["--list-extensions"])
    if rc2 != 0:
        module.fail_json(
            msg="Failed to list Cursor extensions. Is `cursor` available and usable?",
            rc=rc2,
            stdout=out2,
            stderr=err2,
        )
    lines = [line.strip() for line in out2.splitlines() if line.strip()]
    installed = {line: None for line in lines}
    return installed, lines, out2, err2


def main():
    module = AnsibleModule(
        argument_spec=dict(
            name=dict(type="str", required=True),
            state=dict(type="str", choices=["present", "absent"], default="present"),
            cursor_path=dict(type="str", required=False, default=None),
            user_data_dir=dict(type="str", required=False, default=None),
            extensions_dir=dict(type="str", required=False, default=None),
            force=dict(type="bool", default=False),
        ),
        supports_check_mode=True,
    )

    name_in = module.params["name"]
    state = module.params["state"]
    force = module.params["force"]

    ext_name, desired_ver = _parse_name_and_version(name_in)

    cursor_cmd = module.params.get("cursor_path") or shutil.which("cursor")
    if not cursor_cmd:
        module.fail_json(
            msg="`cursor` command not found. Install Cursor or set cursor_path."
        )

    installed_map, raw_lines, list_stdout, list_stderr = _list_extensions(
        module, cursor_cmd
    )

    is_installed = ext_name in installed_map
    installed_ver = installed_map.get(ext_name)

    # Determine if change needed
    changed = False
    action = None

    if state == "present":
        if not is_installed:
            changed = True
            action = "install"
        elif (
            desired_ver is not None
            and installed_ver is not None
            and desired_ver != installed_ver
        ):
            # version mismatch (only possible when --show-versions worked)
            changed = True
            action = "install"
        elif desired_ver is not None and installed_ver is None:
            # Can't verify version; still attempt install to satisfy version request
            changed = True
            action = "install"

    elif state == "absent":
        if is_installed:
            changed = True
            action = "uninstall"

    # check_mode
    if module.check_mode:
        module.exit_json(
            changed=changed,
            installed=raw_lines,
            stdout=list_stdout,
            stderr=list_stderr,
            msg=("Would %s %s" % (action, ext_name)) if action else "No change needed",
        )

    last_out = list_stdout
    last_err = list_stderr

    if action == "install":
        base = _build_base_args(module, cursor_cmd)
        cmd = base + ["--install-extension", name_in]
        if force:
            cmd.append("--force")
        rc, out, err = _run(module, cmd)
        last_out, last_err = out, err
        if rc != 0:
            module.fail_json(
                msg=f"Failed to install extension: {name_in}",
                rc=rc,
                stdout=out,
                stderr=err,
            )

    elif action == "uninstall":
        base = _build_base_args(module, cursor_cmd)
        cmd = base + ["--uninstall-extension", ext_name]
        rc, out, err = _run(module, cmd)
        last_out, last_err = out, err
        if rc != 0:
            module.fail_json(
                msg=f"Failed to uninstall extension: {ext_name}",
                rc=rc,
                stdout=out,
                stderr=err,
            )

    # Re-list to return current state
    _, raw_lines2, _, _ = _list_extensions(module, cursor_cmd)

    module.exit_json(
        changed=changed,
        installed=raw_lines2,
        stdout=last_out,
        stderr=last_err,
        msg="OK",
    )


if __name__ == "__main__":
    main()
