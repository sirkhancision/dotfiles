#!/usr/bin/env zsh

set -e

PIC_DIR=$(xdg-user-dir PICTURES)
IMAGE_NAME=$(date +"%Y-%m-%d-%H-%M-%S").png
SCREENSHOTS_DIR=$PIC_DIR/Screenshots

grim $SCREENSHOTS_DIR/$IMAGE_NAME \
    && paplay $HOME/.config/sway/audio/screen-capture.ogg
wl-copy < $SCREENSHOTS_DIR/$IMAGE_NAME

exit 0
