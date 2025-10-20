#!/usr/bin/env bash

HOMEBREW_PREFIX="/opt/homebrew"
BREW_BIN="$HOMEBREW_PREFIX/bin/brew"
AQUA_BIN="$HOMEBREW_PREFIX/bin/aqua"

if [ ! -x $BREW_BIN ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x $AQUA_BIN ]; then
  $BREW_BIN install aqua
fi

$AQUA_BIN -c ../.config/aquaproj-aqua/aqua.yaml exec -- \
  uvx --with ansible --from ansible-core -- \
  ansible-playbook playbook.yml "$@"
