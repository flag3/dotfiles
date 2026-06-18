from ansible.module_utils.basic import AnsibleModule
import filecmp
import os
import shutil
import tempfile

TMUX_REPLACEMENTS = [
    ("tmux-claude-session-manager", "tmux-codex-session-manager"),
    (
        "launch_key=\"$(get_tmux_option @claude_launch_key 'y')\"",
        "claude_launch_key=\"$(get_tmux_option @claude_launch_key 'y')\"\n"
        "codex_launch_key=\"$(get_tmux_option @codex_launch_key 'Y')\"",
    ),
    (
        'tmux bind-key "$launch_key" \\\n'
        '  run-shell "$CURRENT_DIR/scripts/launch.sh '
        "'#{pane_current_path}' '#{window_id}'\"",
        'tmux bind-key "$claude_launch_key" \\\n'
        '  run-shell "$CURRENT_DIR/scripts/launch.sh claude '
        "'#{pane_current_path}' '#{window_id}'\"\n"
        'tmux bind-key "$codex_launch_key" \\\n'
        '  run-shell "$CURRENT_DIR/scripts/launch.sh codex '
        "'#{pane_current_path}' '#{window_id}'\"",
    ),
]

LAUNCH_REPLACEMENTS = [
    (
        'path="${1:-$PWD}"\nwindow="${2:-}"',
        'target="${1:?target required}"\npath="${2:-$PWD}"\nwindow="${3:-}"',
    ),
    (
        "prefix=\"$(get_tmux_option @claude_session_prefix 'claude-')\"\n"
        "cmd=\"$(get_tmux_option @claude_command 'claude')\"",
        "claude_prefix=\"$(get_tmux_option @claude_session_prefix 'claude-')\"\n"
        "codex_prefix=\"$(get_tmux_option @codex_session_prefix 'codex-')\"\n"
        'case "$target" in\n'
        '  claude) prefix="$claude_prefix"; cmd="$(get_tmux_option @claude_command \'claude\')" ;;\n'
        '  codex) prefix="$codex_prefix"; cmd="$(get_tmux_option @codex_command \'codex\')" ;;\n'
        "  *) tmux display-message \"launch: unknown target '$target'\"; exit 1 ;;\n"
        "esac",
    ),
    (
        'if [[ "$(tmux display-message -p \'#S\')" == "$prefix"* ]]; then',
        'if [[ "$(tmux display-message -p \'#S\')" == "$claude_prefix"*'
        ' || "$(tmux display-message -p \'#S\')" == "$codex_prefix"* ]]; then',
    ),
]

LIST_REPLACEMENTS = [
    (
        "prefix=\"$(get_tmux_option @claude_session_prefix 'claude-')\"",
        "claude_prefix=\"$(get_tmux_option @claude_session_prefix 'claude-')\"\n"
        "codex_prefix=\"$(get_tmux_option @codex_session_prefix 'codex-')\"",
    ),
    (
        "awk -v p=\"$prefix\" 'index($2, p) == 1 { print $2; exit }'",
        'awk -v c="$claude_prefix" -v x="$codex_prefix" '
        "'index($2, c) == 1 || index($2, x) == 1 { print $2; exit }'",
    ),
    (
        "awk -v p=\"$prefix\" 'index($2, p) != 1 { print $1; exit }'",
        'awk -v c="$claude_prefix" -v x="$codex_prefix" '
        "'index($2, c) != 1 && index($2, x) != 1 { print $1; exit }'",
    ),
]

PICKER_REPLACEMENTS = [
    (
        "prefix=\"$(get_tmux_option @claude_session_prefix 'claude-')\"",
        "claude_prefix=\"$(get_tmux_option @claude_session_prefix 'claude-')\"\n"
        "codex_prefix=\"$(get_tmux_option @codex_session_prefix 'codex-')\"",
    ),
    (
        "local now s state at path icon rank ago",
        "local now s state at path icon rank ago label",
    ),
    (
        "tmux list-sessions -F '#{session_name}' 2>/dev/null | grep \"^${prefix}\" | while IFS= read -r s; do",
        """tmux list-sessions -F '#{session_name}' 2>/dev/null | while IFS= read -r s; do
    case "$s" in
      "$claude_prefix"*) label='Claude' ;;
      "$codex_prefix"*) label='Codex ' ;;
      *) continue ;;
    esac""",
    ),
    (
        'printf \'%s\\t%s\\t%s\\t%5s\\t%s\\n\' "$rank" "$s" "$icon" "$ago" "${path/#$HOME/~}"',
        'printf \'%s\\t%s\\t%s\\t%s\\t%5s\\t%s\\n\' "$rank" "$s" "$label" "$icon" "$ago" "${path/#$HOME/~}"',
    ),
    (
        "done | sort -t$'\\t' -k1,1n -k4,4n",
        "done | sort -t$'\\t' -k1,1n -k5,5n",
    ),
    (
        "fzf --ansi --delimiter='\\t' --with-nth=3,4,5",
        "fzf --ansi --delimiter='\\t' --with-nth=3,4,5,6",
    ),
]

module = AnsibleModule(argument_spec={})
codex_plugin = os.path.expanduser("~/.config/tmux/plugins/tmux-codex-session-manager")
changed = False

with tempfile.TemporaryDirectory() as temp_dir:
    work_plugin = os.path.join(temp_dir, "tmux-codex-session-manager")

    def replace_text(relative_path, replacements):
        path = os.path.join(work_plugin, relative_path)
        with open(path, encoding="utf-8") as file:
            text = file.read()
        for old, new in replacements:
            if old not in text:
                module.fail_json(
                    msg="upstream drift: replacement target missing in %s: %r"
                    % (relative_path, old[:60])
                )
            text = text.replace(old, new)
        with open(path, "w", encoding="utf-8") as file:
            file.write(text)

    shutil.copytree(
        os.path.expanduser("~/.config/tmux/plugins/tmux-claude-session-manager"),
        work_plugin,
        ignore=shutil.ignore_patterns(".git"),
    )

    replace_text("claude_session_manager.tmux", TMUX_REPLACEMENTS)
    replace_text("scripts/launch.sh", LAUNCH_REPLACEMENTS)
    replace_text("scripts/list.sh", LIST_REPLACEMENTS)
    replace_text("scripts/picker.sh", PICKER_REPLACEMENTS)

    generated_files = set()
    for root, _, files in os.walk(work_plugin):
        for name in files:
            path = os.path.join(root, name)
            generated_files.add(os.path.relpath(path, work_plugin))

    installed_files = set()
    for root, _, files in os.walk(codex_plugin):
        for name in files:
            path = os.path.join(root, name)
            installed_files.add(os.path.relpath(path, codex_plugin))

    same_content = generated_files == installed_files and all(
        filecmp.cmp(
            os.path.join(work_plugin, path),
            os.path.join(codex_plugin, path),
            shallow=False,
        )
        for path in generated_files
    )

    if not same_content:
        shutil.rmtree(codex_plugin, ignore_errors=True)
        os.makedirs(os.path.dirname(codex_plugin), exist_ok=True)
        shutil.copytree(work_plugin, codex_plugin)
        changed = True

module.exit_json(changed=changed)
