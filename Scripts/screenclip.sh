##!/bin/zsh

pic_dir=$(xdg-user-dir PICTURES)

slurp | grim -g - $pic_dir/Screenshots/scrn-$(date +"%d-%m-%Y-%H-%M-%S").png
paplay $HOME/.config/sway/audio/screen-capture.ogg
image_path=$(echo -n "$pic_dir/Screenshots/" && ls -Art $pic_dir/Screenshots/ | tail -n 1)
wl-copy < $image_path
