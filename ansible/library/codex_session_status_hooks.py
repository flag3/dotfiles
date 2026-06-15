from ansible.module_utils.basic import AnsibleModule
import json
import os

module = AnsibleModule(argument_spec={})

hooks_file = os.path.expanduser("~/.codex/hooks.json")
base = "$HOME/.config/tmux/plugins/tmux-claude-session-manager/scripts/state.sh"
events = [
    ("UserPromptSubmit", "working"),
    ("PermissionRequest", "waiting"),
    ("Stop", "idle"),
]

os.makedirs(os.path.dirname(hooks_file), exist_ok=True)
data = {}
if os.path.exists(hooks_file):
    with open(hooks_file, encoding="utf-8") as file:
        data = json.load(file)

changed = False
data.setdefault("hooks", {})

for event, state in events:
    command = f"{base} {state}"
    hook_entry = {
        "hooks": [
            {
                "type": "command",
                "command": command,
            }
        ],
    }
    data["hooks"].setdefault(event, [])

    if hook_entry in data["hooks"][event]:
        continue

    data["hooks"][event].append(hook_entry)
    changed = True

if changed:
    with open(hooks_file, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2)
        file.write("\n")

module.exit_json(changed=changed)
