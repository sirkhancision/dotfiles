#!/bin/bash
# Switch to the next non-empty workspace in i3wm

for CMD in i3-msg jq; do
	if ! command -v "$CMD" >/dev/null 2>&1; then
		echo "$CMD is not installed"
		exit 1
	fi
done

# Get the names of all workspaces
WORKSPACES="$(i3-msg -t get_workspaces | jq -r '.[].name')"

# Get the name of the currently focused workspace
CURRENT="$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')"

# Get the name of the next non-empty workspace
NEXT="$(grep -A1 "$CURRENT" <<<"$WORKSPACES" | tail -n1)"

# Get the name of the last workspace
LAST="$(tail -n1 <<<"$WORKSPACES")"

# If there is no next workspace, wrap around to the first one
if [ "$CURRENT" -eq "$LAST" ]; then
	NEXT="$(head -n1 <<<"$WORKSPACES")"
fi

# Switch to the next non-empty workspace
i3-msg workspace "$NEXT"
