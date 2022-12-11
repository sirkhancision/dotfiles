#!/bin/bash
# Add a new workspace to the first empty position.

# Get the current workspace names.
WORKSPACES=$(i3-msg -t get_workspaces | jq -r '.[] | .name')
declare -a WS_ARRAY
IFS=$'\n' read -rd '' -a WS_ARRAY <<<"$WORKSPACES"

# Get the number of workspaces.
NUM_WORKSPACES=${#WS_ARRAY[@]}

for ((i = 0; i < NUM_WORKSPACES; i++)); do
	if [ "${WS_ARRAY[$i]}" != $((i + 1)) ]; then
		i3-msg workspace $((i + 1))
		exit 0
	fi
done

i3-msg workspace $((NUM_WORKSPACES + 1))