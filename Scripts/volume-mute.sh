##!/bin/zsh

pactl set-sink-mute @DEFAULT_SINK@ toggle
paplay $HOME/.config/sway/audio/notification.ogg
