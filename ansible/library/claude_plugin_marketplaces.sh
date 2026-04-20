#!/bin/sh

. $1

if claude plugin marketplace list | grep -w "$name"; then
  echo "{\"changed\":false}"
  exit 0
fi

GIT_CONFIG_GLOBAL=/dev/null claude plugin marketplace add $name
echo "{\"changed\":true}"
