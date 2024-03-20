#!/bin/sh -e

. $1

CLOUDSDK_CORE_DISABLE_PROMPTS=1

if gcloud components install "$name" 2>&1 | grep -q "up to date"; then
	echo "{\"changed\":false}"
else
	echo "{\"changed\":true}"
fi
