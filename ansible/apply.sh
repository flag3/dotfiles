#!/usr/bin/env bash

HOMEBREW_PREFIX="/opt/homebrew"
BREW_BIN="$HOMEBREW_PREFIX/bin/brew"
AQUA_BIN="$HOMEBREW_PREFIX/bin/aqua"
CHEZMOI_BIN="$HOMEBREW_PREFIX/bin/chezmoi"

if [ ! -x $BREW_BIN ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x $AQUA_BIN ]; then
  $BREW_BIN install aqua
fi

if [ ! -x $CHEZMOI_BIN ]; then
  $BREW_BIN install chezmoi
fi

# Deploy dotfiles. Prompts for git identity on first run, then reuses it.
$CHEZMOI_BIN init --apply --source "$(cd .. && pwd)"

$AQUA_BIN -c ../dot_config/aquaproj-aqua/aqua.yaml exec -- \
  uvx --managed-python --with ansible --from ansible-core -- \
  ansible-playbook playbook.yml "$@"
