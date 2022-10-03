##!/bin/zsh

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
    sed 's/Volume: //' | \
    xargs -I {} $SHELL -c 'printf "%0.0f\n" "{} * 100"')

if [ ! case $volume in *MUTED* ] || [ $volume -ne 0 ]; then 
    if [[ $volume -gt 50 ]]; then
        echo " $volume%"
    elif [[ $volume -gt 25 ]]; then
        echo " $volume%"
    elif [[ $volume -gt 0 ]]; then
        echo " $volume%"
    fi
else
    echo "MUTE"
fi
