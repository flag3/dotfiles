set -gx LANG en_US.UTF-8
set fish_greeting ""

set -gx XDG_CONFIG_HOME $HOME/.config

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
alias pn pnpm
alias cz chezmoi
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

fish_add_path -g ~/bin ~/.local/bin

set -l root_path (dirname (status --current-filename))

if type -q eza
    alias ll "eza -l -g --icons=auto"
    alias lla "ll -a"
end

if type -q bat
    alias bat "bat --theme \"Solarized (light)\""
    alias less bat
end

# Homebrew
set -l homebrew_prefix /opt/homebrew
fish_add_path -g $homebrew_prefix/bin $homebrew_prefix/sbin

# 1Password SSH agent
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Android SDK
set -gx ANDROID_HOME $HOME/Library/Android/sdk
if test -d $ANDROID_HOME
    fish_add_path -a $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
end

# React Native editor
if type -q subl
    set -gx REACT_EDITOR subl
end

# Java
set -l android_java_home /Applications/Android\ Studio.app/Contents/jbr/Contents/Home
if test -x $android_java_home/bin/java
    set -gx JAVA_HOME $android_java_home
else if test -x /usr/libexec/java_home
    set -l detected_java_home (/usr/libexec/java_home -v 17 2>/dev/null)
    if test $status -eq 0; and test -n "$detected_java_home"
        set -gx JAVA_HOME $detected_java_home
    end
end

# Google Cloud SDK
set -l google_cloud_sdk_bin_path $homebrew_prefix/share/google-cloud-sdk/bin
if test -d $google_cloud_sdk_bin_path
    set -gx CLOUDSDK_PYTHON (command -v python)
    fish_add_path -g $google_cloud_sdk_bin_path
end

# fzf.fish
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
set -g FZF_ENABLE_OPEN_PREVIEW 1

# Docker
if type -q docker
    set -gx DOCKER_BUILDKIT 1
    set -gx COMPOSE_DOCKER_CLI_BUILD 1
end

# Go
if type -q go
    set -gx GOPATH $HOME/.go
    fish_add_path -g $GOPATH/bin
end

# npm
set -l npm_bin_path $HOME/.npm/bin
if test -d $npm_bin_path
    fish_add_path -g $npm_bin_path
end
set -gx NPM_PKG_GITHUB_PAT "op://2442cozdn6slbp7xxuqldkydjm/kp5feviv6zrc5zcrqxwzbk7ukq/token"

# Rust
set -l rust_include $HOME/.cargo/env.fish
if test -r $rust_include
    source $rust_include
else
    fish_add_path -g $HOME/.cargo/bin
end

# Python
set -l python_venv_path $HOME/.venv
if test -d $python_venv_path/bin
    set -gx VIRTUAL_ENV $python_venv_path
    fish_add_path -g $python_venv_path/bin
    alias pip "uv pip"
end

# Aqua
if type -q aqua
    fish_add_path -g (aqua root-dir)/bin
    set -gx AQUA_GLOBAL_CONFIG $HOME/.config/aquaproj-aqua/aqua.yaml
end

# Lean
set -l lean_path $HOME/.elan
if test -d $lean_path
    fish_add_path -g $lean_path/bin
end

set -l local_config $root_path/config-local.fish
if test -f $local_config
    source $local_config
end
