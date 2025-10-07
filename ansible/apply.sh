#!/usr/bin/env bash

HOMEBREW_PREFIX="/opt/homebrew"
BREW_BIN="$HOMEBREW_PREFIX/bin/brew"
ANSIBLE_PLAYBOOK_BIN="$HOMEBREW_PREFIX/bin/ansible-playbook"

if [ ! -x $BREW_BIN ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x $ANSIBLE_PLAYBOOK_BIN ]; then
  $BREW_BIN install ansible
fi

export PATH="$HOMEBREW_PREFIX/bin:$PATH"
$ANSIBLE_PLAYBOOK_BIN playbook.yml "$@"
