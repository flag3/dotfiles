#!/usr/bin/env bash

HOMEBREW_PREFIX="/opt/homebrew"
BREW_BIN="$HOMEBREW_PREFIX/bin/brew"
MISE_BIN="$HOMEBREW_PREFIX/bin/mise"
VENV="$HOME/.local/share/dotfiles-ansible"

if [ ! -x $BREW_BIN ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x $MISE_BIN ]; then
  $BREW_BIN install mise
fi

if ! "$VENV/bin/python" -V >/dev/null 2>&1; then
  MISE_GLOBAL_CONFIG_FILE=../.config/mise/config.toml $MISE_BIN exec python -- python -m venv --clear "$VENV"
fi

"$VENV/bin/pip" install -q -U ansible-core
"$VENV/bin/ansible-galaxy" collection install -U community.general >/dev/null
"$VENV/bin/ansible-playbook" playbook.yml "$@"
