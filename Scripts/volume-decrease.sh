##!/bin/zsh

pactl set-sink-volume @DEFAULT_SINK@ -5%
paplay $HOME/.config/sway/audio/notification.ogg
