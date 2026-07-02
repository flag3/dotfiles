set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-light
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always
set -g fish_color_command blue

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias c claude
alias claude-yolo "claude --dangerously-skip-permissions"
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
fish_add_path -g ~/.local/bin ~/bin

set HOMEBREW_PREFIX /opt/homebrew
fish_add_path -g "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# docker
if test -x (command -v docker)
    set -gx DOCKER_BUILDKIT 1
    set -gx COMPOSE_DOCKER_CLI_BUILD 1
end

# go
if test -x (command -v go)
    set -gx GOPATH $HOME/.go
    fish_add_path -g "$GOPATH/bin"
end

# npm
set NPM_BIN_PATH $HOME/.npm/bin
if test -d $NPM_BIN_PATH
    fish_add_path -g $NPM_BIN_PATH
end

set -gx NPM_PKG_GITHUB_PAT "op://2442cozdn6slbp7xxuqldkydjm/kp5feviv6zrc5zcrqxwzbk7ukq/token"

# python
set PYTHON_INCLUDE $HOME/.venv/bin/activate.fish
if test -r $PYTHON_INCLUDE
    set VIRTUAL_ENV_DISABLE_PROMPT true
    source $PYTHON_INCLUDE
    alias pip "uv pip"
end

# gcloud-cli
set GOOGLE_CLOUD_SDK_BIN_PATH $HOMEBREW_PREFIX/share/google-cloud-sdk/bin
if test -d $GOOGLE_CLOUD_SDK_BIN_PATH
    set -gx CLOUDSDK_PYTHON (which python)
    fish_add_path -g $GOOGLE_CLOUD_SDK_BIN_PATH
end

# aqua
if test -x (command -v aqua)
    fish_add_path -g (aqua root-dir)/bin
    set -gx AQUA_GLOBAL_CONFIG $HOME/.config/aquaproj-aqua/aqua.yaml
end

if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# lean
set LEAN_PATH $HOME/.elan
if test -d $LEAN_PATH
    fish_add_path -g "$LEAN_PATH/bin"
end

# fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end
