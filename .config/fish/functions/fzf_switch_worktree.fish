function fzf_switch_worktree
    set -l worktree_path (
        gwq list --json 2>/dev/null \
            | jq -r '.[] | "\(.branch)\t\(.path)"' \
            | fzf --layout reverse --delimiter \t --with-nth 1 --preview 'git -C {2} log --oneline --color=always -20' \
            | cut -f2
    )
    if test -n "$worktree_path"
        builtin cd $worktree_path
        commandline -r ''
    end
    commandline -f repaint
end
