#!/bin/bash

set -e

PIC_DIR=$(xdg-user-dir PICTURES)
IMAGE_NAME=$(date +"%Y-%m-%d-%H-%M-%S").png
SCREENSHOTS_DIR=$PIC_DIR/Screenshots

slurp | grim -g - "$SCREENSHOTS_DIR"/"$IMAGE_NAME" &&
	paplay "$HOME"/.config/sway/audio/screen-capture.ogg
wl-copy -t image/png <"$SCREENSHOTS_DIR"/"$IMAGE_NAME"

NOTIFICATION_TEXT="<i>$IMAGE_NAME</i>\nCopiado para a área de transferência."
dunstify 'Captura de tela' "$NOTIFICATION_TEXT" -I "$SCREENSHOTS_DIR"/"$IMAGE_NAME"

exit 0
