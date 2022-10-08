#!/usr/bin/env zsh 

set -e

ENABLED=
DISABLED=
DELAY=0.2

while sleep $DELAY; do
    COUNT=$(dunstctl count waiting)
    if [ $COUNT -ne 0 ]; then 
        DISABLED=" $COUNT"
    fi

    STATUS=$(dunstctl is-paused)
    if [[ $STATUS = "false" ]]; then 
        printf "$ENABLED\n"
    else 
        printf "$DISABLED\n"
    fi
done

exit 0
