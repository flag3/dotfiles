# Load KEY=VALUE entries from a dotenv-style file.
function envsource
    if test (count $argv) -ne 1; or not test -r $argv[1]
        echo "Usage: envsource <readable-file>" >&2
        return 1
    end

    for line in (string match -rv '^\s*(#|$)' < $argv[1])
        set -l item (string split -m 1 '=' $line)
        if test (count $item) -eq 2; and string match -rq '^[A-Za-z_][A-Za-z0-9_]*$' -- $item[1]
            set -gx $item[1] $item[2]
            echo "Exported key $item[1]"
        end
    end
end
