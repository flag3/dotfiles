set fish_greeting ""

set HOMEBREW_PREFIX /opt/homebrew
fish_add_path -g "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
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
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# 1password
if [ -x (command -v op) ]
    alias pnpm "op run --no-masking -- pnpm"
end

# go
if [ -x (command -v go) ]
    set -gx GOPATH "$HOME/.go"
    fish_add_path -g "$GOPATH/bin"
end

# npm
set NPM_PATH "$HOME/.npm/bin"
if [ -d $NPM_PATH ]
    fish_add_path -g $NPM_PATH
end

set -gx NPM_PKG_GITHUB_PAT "op://2442cozdn6slbp7xxuqldkydjm/kp5feviv6zrc5zcrqxwzbk7ukq/token"

# python
set PYTHON_INCLUDE "$HOME/.venv/bin/activate.fish"
if [ -r $PYTHON_INCLUDE ]
    set VIRTUAL_ENV_DISABLE_PROMPT true
    source $PYTHON_INCLUDE
end

# aqua
if [ -x (command -v aqua) ]
    fish_add_path -g (aqua root-dir)/bin
    set -gx AQUA_GLOBAL_CONFIG $HOME/.config/aquaproj-aqua/aqua.yaml
end

if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# lean
set LEAN_PATH "$HOME/.elan"
if [ -d $LEAN_PATH ]
    fish_add_path -g "$LEAN_PATH/bin"
end

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0

set LOCAL_CONFIG "$HOME/.config/fish/config-local.fish"
if [ -r $LOCAL_CONFIG ]
    source $LOCAL_CONFIG
end
