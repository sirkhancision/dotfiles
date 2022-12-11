#!/bin/sh
# dotman - Dotfiles Manager
# Written in POSIX shell
# by sirkhancision

# adjust according to the directory of your dotfiles
REPO_DIR="$HOME/dotfiles"

# just add a file to the pseudo-array, when you need to add a new file
FILES=".config/dunst
.config/fontconfig
.config/gitui
.config/gtk-3.0
.config/helix
.config/i3
.config/kitty
.config/picom
.config/polybar
.config/qt5ct
.config/qt6ct
.config/redshift
.config/rofi
.config/betterlockscreenrc
.config/starship.toml
.icons
.themes
.zprofile
.zshrc
"

greeting() {
    printf "Options:
[0] Exit
[1] Link dotfiles
[2] Edit file\n"
}

link_files() {
    echo "Do you want to link your dotfiles to their path? <y/n>"
    read -r PROMPT
    if [ "$PROMPT" = "y" ] || [ "$PROMPT" = "Y" ] || [ "$PROMPT" = "yes" ] || [ "$PROMPT" = "Yes" ]; then
        mkdir -p "$HOME/.config"

        if [ -n "$FILES" ]; then
            # iterate over pseudo-array of files
            printf "%s" "$FILES" |
                while IFS="" read -r FILE; do
                    if echo "$FILE" | grep -q ".config"; then
                        ln -sfv "$REPO_DIR/$FILE" "$HOME/.config"
                    else
                        ln -sfv "$REPO_DIR/$FILE" "$HOME"
                    fi
                done

            echo "Done linking files"
        else
            echo "No files added, please add at least one file"
        fi
    fi
}

# use skim and bat to select a file with a colored preview of them
# and then open them with your default editor
edit_file() {
    if [ -n "${EDITOR+x}" ]; then
        if [ "$(sk -V)" ]; then
            if [ "$(bat -V)" ]; then
                FILE="$(find .config -type f | sk --preview="bat {} --color=always")"
                if [ -n "$FILE" ]; then
                    $EDITOR "$REPO_DIR/$FILE"
                fi
            else
                echo "bat isn't installed"
            fi
        else
            echo "skim isn't installed"
        fi
    else
        printf "\nThere isn't a default editor (\$EDITOR isn't set)\n"
    fi
}

# main program
printf "dotman - Dotfiles Manager
by sirkhancision\n\n"

# : = true
while :; do
    greeting
    read -r OPTION

    case $OPTION in
    0) break ;;
    1) link_files ;;
    2) edit_file ;;
    *) echo "Invalid option" ;;
    esac
done
