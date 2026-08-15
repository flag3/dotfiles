function load_secret_env
    if test (count $argv) -eq 0
        echo "Usage: load_secret_env <command1> [command2] ..."
        return 1
    end

    for cmd in $argv
        alias $cmd "op run --no-masking -- $cmd"
    end
end
