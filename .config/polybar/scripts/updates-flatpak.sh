#!/bin/sh

updates=$(echo 'n' | flatpak update 2>/dev/null | grep -c '<')

if [ "$updates" -gt 0 ]; then
	echo "$updates"
else
	echo ""
fi
