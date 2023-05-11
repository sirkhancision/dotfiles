#!/bin/bash

check_command() {
	command -v "$1" >/dev/null 2>&1 || {
		echo "$1 is not installed"
		exit 1
	}
}

CHECK_COMMANDS=(
	"dunstify"
	"maim"
	"paplay"
	"xclip"
	"xdg-user-dir"
)

for CMD in "${CHECK_COMMANDS[@]}"; do
	check_command "$CMD"
done

set -e

PIC_DIR=$(xdg-user-dir PICTURES)
IMAGE_NAME=$(date +"%Y-%m-%d_%H-%M-%S").png
SCREENSHOTS_DIR="$PIC_DIR/Screenshots"

mkdir -p "$SCREENSHOTS_DIR"

maim -i "$(xdotool getactivewindow)" "$SCREENSHOTS_DIR/$IMAGE_NAME" &&
	paplay "$HOME/.config/i3/audio/screen-capture.ogg"

xclip -sel clip -t image/png <"$SCREENSHOTS_DIR/$IMAGE_NAME"

NOTIFICATION_TEXT="<i>$IMAGE_NAME</i>\nCopiado para a área de transferência"
dunstify 'Captura de tela' "$NOTIFICATION_TEXT" -I "$SCREENSHOTS_DIR/$IMAGE_NAME"
