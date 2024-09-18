#!/opt/homebrew/bin/fish

. $argv[1]

if fisher list | grep -q "$name"
    echo "{\"changed\":false}"
    exit 0
end

fisher install "$name"
echo "{\"changed\":true}"
