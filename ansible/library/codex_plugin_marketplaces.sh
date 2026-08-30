#!/bin/sh

. "$1"
set -eu

marketplace_name=$(basename "$name" | tr '[:upper:]' '[:lower:]')

if codex plugin marketplace list | awk -v marketplace_name="$marketplace_name" '
  NR > 1 && $1 == marketplace_name { found = 1 }
  END { exit !found }
'; then
  echo "{\"changed\":false}"
  exit 0
fi

GIT_CONFIG_GLOBAL=/dev/null codex plugin marketplace add "$name"
echo "{\"changed\":true}"
