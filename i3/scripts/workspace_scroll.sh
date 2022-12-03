#!/bin/bash

# switch to the next non-empty workspace in i3wm
# (i.e. the next workspace that has at least one window in it).
# This script is intended to be bound to a key in i3's config file.

# Get the names of all workspaces.
WORKSPACES=$(i3-msg -t get_workspaces | jq -r '.[].name')

# Get the name of the currently focused workspace.
current=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Get the name of the next non-empty workspace.
next=$(echo "$WORKSPACES" | grep -A1 "$current" | tail -n1)

# Get the name of the last workspace
last=$(echo "$WORKSPACES" | tail -n1)

# If there is no next workspace, wrap around to the first one.
if [ "$current" -eq "$last" ]; then
	next=$(echo "$WORKSPACES" | head -n1)
fi

# Switch to the next non-empty workspace.
i3-msg workspace "$next"
