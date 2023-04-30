#!/bin/sh

if ! command -v xdg-user-dir; then
	echo "xdg-user-dir is not installed"
	exit 1
fi

if ! command -v maim; then
	echo "maim is not installed"
	exit 1
fi

if ! command -v paplay; then
	echo "paplay is not installed"
	exit 1
fi

if ! command -v xclip; then
	echo "xclip is not installed"
	exit 1
fi

if ! command -v dunstify; then
	echo "dunstify is not installed"
	exit 1
fi

set -e

PIC_DIR=$(xdg-user-dir PICTURES)
IMAGE_NAME=$(date +"%Y-%m-%d_%H-%M-%S").png
if [ ! -d "$PIC_DIR/Screenshots" ]; then
	mkdir -p "$PIC_DIR/Screenshots"
fi
SCREENSHOTS_DIR=$PIC_DIR/Screenshots

maim "$SCREENSHOTS_DIR"/"$IMAGE_NAME" &&
	paplay "$HOME"/.config/i3/audio/screen-capture.ogg
xclip -sel clip -t image/png <"$SCREENSHOTS_DIR"/"$IMAGE_NAME"

NOTIFICATION_TEXT="<i>$IMAGE_NAME</i>\nCopiado para a área de transferência."
dunstify 'Captura de tela' "$NOTIFICATION_TEXT" -I "$SCREENSHOTS_DIR"/"$IMAGE_NAME"

exit 0
