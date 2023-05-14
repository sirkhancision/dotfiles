#!/bin/bash
# dotman - Dotfiles Manager
# by sirkhancision

# Function to load configuration from .dotmanrc file
load_dotmanrc() {
	local DOTMANRC_FILE="$HOME/dotfiles/.dotmanrc"

	if [ -f "$DOTMANRC_FILE" ]; then
		# Load variables from .dotmanrc
		eval "$(cat "$DOTMANRC_FILE")"
	fi
}

load_dotmanrc

if ! cd "$REPO_DIR"; then
	echo "The dotfiles directory pointed to by REPO_DIR doesn't exist"
	echo "Please, create it and put dotman in it"
	exit 1
fi

# end successfully if, for example, the user presses Ctrl+C
# to exit the script
end_script() {
	printf "\n"
	exit 0
}

trap 'end_script' INT

# check if program is installed
check_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "$2 is not installed"
		exit 1
	fi
}

# declare dictionary
declare -A CHECK_COMMANDS=(
	["bat"]="bat"
	["fd"]="fd"
	["gitui"]="fd"
	["sk"]="skim"
)

for KEY in "${!CHECK_COMMANDS[@]}"; do
	check_command "$KEY" "${CHECK_COMMANDS[$KEY]}"
done

# update dotfiles from the remote
update_dotfiles() {
	BEFORE=$(git rev-parse HEAD)
	git -C "$REPO_DIR" pull origin i3wm
	AFTER=$(git rev-parse HEAD)
	if [[ $BEFORE != "$AFTER" ]]; then
		link_files
	fi
}

# create symbolic links for your dotfiles to their real paths
link_files() {
	read -rp "Do you want to link your dotfiles to their path? <y/n> " OPTION
	if [[ $OPTION =~ ^[Yy]$ ]]; then
		mkdir -p "$HOME/.config"

		if [ "${#FILES[@]}" -eq 0 ]; then
			echo "No files added, please add at least one file"
		else
			for FILE in "${FILES[@]}"; do
				if [[ $FILE == ".config" ]]; then
					DIRECTORY="$HOME/.config"
					ln -sfv "$REPO_DIR/$FILE/"* "$DIRECTORY"
				else
					DIRECTORY="$HOME"
					ln -sfv "$REPO_DIR/$FILE" "$DIRECTORY"
				fi
			done

			echo "Done linking files"
		fi
	fi
}

# use skim and bat to select a file with a colored preview of them
# and then open them with your default editor
edit_file() {
	if [ -z "${EDITOR+x}" ]; then
		printf "\nThere isn't a default editor (the EDITOR environment variable isn't set)\n"
	else
		# shellcheck disable=SC2164
		cd "$REPO_DIR"

		local FILE
		mapfile -t FILES < <(fd --type f --hidden)
		while true; do
			FILE=$(printf "%s\n" "${FILES[@]}" | sk --preview="bat {} --color=always")
			if [ -z "$FILE" ]; then
				break
			else
				$EDITOR "$FILE"
			fi
		done
	fi
}

# use gitui to execute operations with git in your dotfiles
# local repository
git_ui() {
	# shellcheck disable=SC2164
	cd "$REPO_DIR"
	gitui
}

# main program
printf "dotman - Dotfiles Manager
by sirkhancision\n\n"

while true; do
	read -rp "Options:
[1] Link dotfiles
[2] Edit file
[3] Open gitui
[4] Update dotfiles
" OPTION

	case $OPTION in
	1) link_files ;;
	2) edit_file ;;
	3) git_ui ;;
	4) update_dotfiles ;;
	*) echo "Invalid option" ;;
	esac
done
