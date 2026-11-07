alias ls "ls -p --color=auto"

# 1Password SSH agent
if test -S $HOME/.1password/agent.sock
    set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock
end
