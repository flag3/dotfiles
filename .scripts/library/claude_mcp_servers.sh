#!/bin/sh

. $1

if claude mcp list | grep -w "$name"; then
  echo "{\"changed\":false}"
  exit 0
fi

base_command="claude mcp add --scope user"

if [ -n "$command" ]; then
  final_command="$base_command $name -- $command"
elif [ -n "$url" ]; then
  final_command="$base_command --transport sse $name $url"
fi

$final_command
echo "{\"changed\":true}"
