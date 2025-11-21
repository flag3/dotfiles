#!/bin/sh

. $1

if codex mcp list | grep -w "$name"; then
  echo "{\"changed\":false}"
  exit 0
fi

base_command="codex mcp add"

if [ -n "$command" ]; then
  final_command="$base_command $name --env AQUA_GLOBAL_CONFIG=/Users/$(whoami)/.config/aquaproj-aqua/aqua.yaml -- $command"
elif [ -n "$url" ]; then
  final_command="$base_command $name --url $url --enable experimental_use_rmcp_client"
fi

$final_command
echo "{\"changed\":true}"
