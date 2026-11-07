function pnpm --wraps pnpm
    if command -q gh
        set -fx NODE_AUTH_TOKEN (gh auth token 2>/dev/null)
    end

    command pnpm $argv
end
