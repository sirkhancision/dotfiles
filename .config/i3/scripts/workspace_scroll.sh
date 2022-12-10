#!/bin/sh
# Switch to the next non-empty workspace in i3wm

# Get the names of all workspaces
WORKSPACES=$(i3-msg -t get_workspaces | jq -r '.[].name')

# Get the name of the currently focused workspace
CURRENT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

# Get the name of the next non-empty workspace
NEXT=$(echo "$WORKSPACES" | grep -A1 "$CURRENT" | tail -n1)

# Get the name of the last workspace
LAST=$(echo "$WORKSPACES" | tail -n1)

# If there is no next workspace, wrap around to the first one
if [ "$CURRENT" -eq "$LAST" ]; then
	NEXT=$(echo "$WORKSPACES" | head -n1)
fi

# Switch to the next non-empty workspace
i3-msg workspace "$NEXT"
