#!/bin/bash

for CMD in dunstify maim paplay xclip xdg-user-dir; do
	if ! command -v "$CMD" >/dev/null 2>&1; then
		echo "$CMD is not installed"
		exit 1
	fi
done

set -e

PIC_DIR="$(xdg-user-dir PICTURES)"
IMAGE_NAME="$(date +"%Y-%m-%d_%H-%M-%S").png"
SCREENSHOTS_DIR="$PIC_DIR/Screenshots"

mkdir -p "$SCREENSHOTS_DIR"

maim -i "$(xdotool getactivewindow)" "$SCREENSHOTS_DIR/$IMAGE_NAME" &&
	paplay "$HOME/.config/i3/audio/screen-capture.ogg"

xclip -sel clip -t image/png <"$SCREENSHOTS_DIR/$IMAGE_NAME"

NOTIFICATION_TEXT="<i>$IMAGE_NAME</i>\nCopiado para a área de transferência"
dunstify 'Captura de tela' "$NOTIFICATION_TEXT" -I "$SCREENSHOTS_DIR/$IMAGE_NAME"
