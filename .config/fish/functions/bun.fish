function bun --wraps bun
    if command -q gh
        set -fx NODE_AUTH_TOKEN (gh auth token 2>/dev/null)
    end

    command bun $argv
end
