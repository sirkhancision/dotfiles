#!/bin/bash
# Switch to the Nth active workspace in i3wm

for CMD in i3-msg jq; do
	if ! command -v "$CMD" >/dev/null 2>&1; then
		echo "$CMD is not installed"
		exit 1
	fi
done

# Define the workspace number to switch to
TARGET_WORKSPACE="$1"

# Get the names of all workspaces
WORKSPACES="$(i3-msg -t get_workspaces | jq -r '.[].name')"

# Get the name of the Nth active workspace
NEXT="$(sed -n "${TARGET_WORKSPACE}s/^\(.\).*/\1/p" <<<"$WORKSPACES")"

# If there is no active workspace at the position, exit
if [ -z "$NEXT" ]; then
	echo "No active workspace found at position $TARGET_WORKSPACE"
	exit 1
fi

# Switch to the Nth active workspace
i3-msg workspace "$NEXT"
