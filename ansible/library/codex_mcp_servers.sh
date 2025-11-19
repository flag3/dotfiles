#!/bin/sh

. $1

if codex mcp list | grep -w "$name"; then
  echo "{\"changed\":false}"
  exit 0
fi

codex mcp add $name --env AQUA_GLOBAL_CONFIG=/Users/$(whoami)/.config/aquaproj-aqua/aqua.yaml -- $command
echo "{\"changed\":true}"
