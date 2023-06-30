#!/bin/bash
# Add a new workspace to the first empty position.

for CMD in i3-msg jq; do
	if ! command -v "$CMD" >/dev/null 2>&1; then
		echo "$CMD is not installed"
		exit 1
	fi
done

# Get the current workspace names.
IFS=$'\n' read -rd '' -a WS_ARRAY <<<"$(i3-msg -t get_workspaces | jq -r '.[] | .name')"

# Get the number of workspaces.
NUM_WORKSPACES="${#WS_ARRAY[@]}"

for INDEX in $(seq 1 "$NUM_WORKSPACES"); do
	if [ "${WS_ARRAY[INDEX]}" -ne "$((INDEX + 1))" ]; then
		i3-msg workspace "$((INDEX + 1))"
		exit 0
	fi
done

i3-msg workspace "$((NUM_WORKSPACES + 1))"
