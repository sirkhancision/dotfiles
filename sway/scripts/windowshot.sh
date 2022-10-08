#!/usr/bin/env zsh

PIC_DIR=$(xdg-user-dir PICTURES)

swaymsg -t get_tree | \
    jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | \
    slurp | grim -g - $PIC_DIR/Screenshots/scrn-$(date +"%Y-%m-%d-%H-%M-%S").png \
    && paplay $HOME/.config/sway/audio/screen-capture.ogg
image_path=$(echo -n "$PIC_DIR/Screenshots/" && ls -Art $PIC_DIR/Screenshots/ | tail -n 1)
wl-copy < $image_path
