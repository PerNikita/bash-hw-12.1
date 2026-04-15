#!/bin/bash

set -o pipefail

NAME_SERVICE=$1

if [ -n $NAME_SERVICE ]; then
	PROCESS=$(pgrep $NAME_SERVICE | wc -l)
fi

echo $PROCESS
