#!/bin/bash
# Switch to the Nth active workspace in i3wm

check_command() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "$1 is not installed"
		exit 1
	}
}

CHECK_COMMANDS=(
	"i3-msg"
	"jq"
)

for CMD in "${CHECK_COMMANDS[@]}"; do
	check_command "$CMD"
done

# Define the workspace number to switch to
N=$1

# Get the names of all workspaces
WORKSPACES=$(i3-msg -t get_workspaces | jq -r '.[].name')

# Get the name of the Nth active workspace
NEXT=$(echo "$WORKSPACES" | sed -n "${N}s/^\(.\).*/\1/p")

# If there is no active workspace at the position, exit
if [ -z "$NEXT" ]; then
	echo "No active workspace found at position $N"
	exit 1
fi

# Switch to the Nth active workspace
i3-msg workspace "$NEXT"
