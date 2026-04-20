#!/bin/sh

. $1

if claude plugin list | grep -w "$name"; then
  echo "{\"changed\":false}"
  exit 0
fi

GIT_CONFIG_GLOBAL=/dev/null claude plugin install $name
echo "{\"changed\":true}"
