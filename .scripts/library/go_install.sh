#!/bin/sh -e

. $1

GOPATH="$HOME/.go"

if [ -x "$GOPATH/bin/$(basename $name)" ]; then
	echo "{\"changed\":false}"
	exit 0
fi

go install "$name@latest"

echo "{\"changed\":true}"
