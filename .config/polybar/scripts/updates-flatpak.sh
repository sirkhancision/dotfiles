#!/bin/sh

updates=$(echo 'n' | flatpak update 2>/dev/null | grep -c '<')

if [ "$updates" -gt 0 ]; then
    printf '%s\n' "$updates"
else
    printf '\n'
fi
