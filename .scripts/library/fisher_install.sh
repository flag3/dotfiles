#!/bin/sh -e

name=$1

FISHER_PATH="$HOME/.config/fish/functions/fisher.fish"

if [ ! -f "$FISHER_PATH" ]; then
	curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o "$FISHER_PATH"
	fish -c "fisher install jorgebucaran/fisher"
fi

if fish -c "fisher list | grep -q '$name'"; then
	echo "{\"changed\":false}"
	exit 0
fi

fish -c "fisher install $name"

echo "{\"changed\":true}"
