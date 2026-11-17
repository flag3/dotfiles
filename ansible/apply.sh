#!/bin/sh

HOMEBREW_PREFIX="/opt/homebrew"
BREW_BIN="$HOMEBREW_PREFIX/bin/brew"
MISE_BIN="$HOMEBREW_PREFIX/bin/mise"

if [ ! -x $BREW_BIN ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x $MISE_BIN ]; then
  $BREW_BIN install mise
fi

MISE_GLOBAL_CONFIG_FILE=../.config/mise/config.toml exec $MISE_BIN exec uv -- \
  uvx --managed-python --python '<3.15' --with ansible --from ansible-core -- \
  ansible-playbook playbook.yml "$@"
