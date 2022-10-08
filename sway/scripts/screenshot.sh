#!/usr/bin/env zsh

PIC_DIR=$(xdg-user-dir PICTURES)

grim $PIC_DIR/Screenshots/scrn-$(date +"%Y-%m-%d-%H-%M-%S").png
paplay $HOME/.config/sway/audio/screen-capture.ogg
image_path=$(echo -n "$PIC_DIR/Screenshots/" && ls -Art $PIC_DIR/Screenshots/ | tail -n 1)
wl-copy < $image_path
