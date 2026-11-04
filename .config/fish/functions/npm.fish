function npm --wraps npm
    if command -q gh
        set -fx NODE_AUTH_TOKEN (gh auth token 2>/dev/null)
    end

    command npm $argv
end
