##!/bin/zsh

pic_dir=$(xdg-user-dir PICTURES)

swaymsg -t get_tree | \
    jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | \
    slurp | grim -g - $pic_dir/Screenshots/scrn-$(date +"%d-%m-%Y-%H-%M-%S").png \
    && paplay $HOME/.config/sway/audio/screen-capture.ogg
image_path=$(echo -n "$pic_dir/Screenshots/" && ls -Art $pic_dir/Screenshots/ | tail -n 1)
wl-copy < $image_path