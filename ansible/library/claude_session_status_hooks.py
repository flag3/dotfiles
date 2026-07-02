from ansible.module_utils.basic import AnsibleModule
import json
import os

module = AnsibleModule(argument_spec={})

settings = os.path.expanduser("~/.claude/settings.json")
base = "$HOME/.config/tmux/plugins/tmux-agent-session-manager/scripts/state.sh"
events = [
    ("UserPromptSubmit", "", "working"),
    ("Notification", "permission_prompt", "waiting"),
    ("PreToolUse", "AskUserQuestion", "waiting"),
    ("Stop", "", "idle"),
]

os.makedirs(os.path.dirname(settings), exist_ok=True)
data = {}
if os.path.exists(settings):
    with open(settings, encoding="utf-8") as file:
        data = json.load(file)

changed = False
data.setdefault("hooks", {})

for event, matcher, state in events:
    command = f"{base} {state}"
    hook_entry = {
        "matcher": matcher,
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
    with open(settings, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=2)
        file.write("\n")

module.exit_json(changed=changed)
