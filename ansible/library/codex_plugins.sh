#!/bin/sh

. "$1"
set -eu

if codex plugin list --json | jq -e --arg plugin_id "$name" '
  .installed[]
  | select(.pluginId == $plugin_id and .enabled)
' >/dev/null; then
  echo "{\"changed\":false}"
  exit 0
fi

GIT_CONFIG_GLOBAL=/dev/null codex plugin add "$name"
echo "{\"changed\":true}"
