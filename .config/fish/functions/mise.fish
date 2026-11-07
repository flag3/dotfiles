function mise --wraps mise
    if command -q gh
        set -fx GITHUB_TOKEN (gh auth token 2>/dev/null)
    end

    command mise $argv
end
