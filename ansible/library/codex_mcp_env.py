from ansible.module_utils.basic import AnsibleModule
import json
import os

module = AnsibleModule(argument_spec={})
rc, out, err = module.run_command(["codex", "mcp", "list", "--json"])
entries = json.loads(out)
aqua_path = os.path.expanduser("~/.config/aquaproj-aqua/aqua.yaml")
changed = False

for entry in entries:
    transport = entry.get("transport")
    if transport.get("type") != "stdio":
        continue

    env = transport.get("env")
    if not isinstance(env, dict):
        env = dict()
    if env.get("AQUA_GLOBAL_CONFIG"):
        continue
    env["AQUA_GLOBAL_CONFIG"] = aqua_path

    name = entry.get("name")
    command = transport.get("command")
    args = transport.get("args")

    cmd = ["codex", "mcp", "add", name]
    for key in env:
        cmd.extend(["--env", f"{key}={env[key]}"])
    cmd.append("--")
    cmd.append(command)
    cmd.extend(args)

    module.run_command(["codex", "mcp", "remove", name])
    module.run_command(cmd)
    changed = True

module.exit_json(changed=changed)
