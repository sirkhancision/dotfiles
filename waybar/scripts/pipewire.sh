##!/bin/zsh

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
    sed 's/Volume: //' | \
    xargs -I {} zsh -c 'qalc -t -s "decimal comma off" "{} * 100"')

if [ $(echo $volume | grep "MUTED") -eq "" ] || [ $(echo $volume) -ne 0 ]; then 
    if [[ $volume -le 100 && $volume -gt 50 ]]; then
        echo " $volume%"
    elif [[ $volume -le 50 && $volume -gt 25 ]]; then
        echo " $volume%"
    elif [[ $volume -le 25 && $volume -gt 0 ]]; then
        echo " $volume%"
    fi
else
    echo "MUTE"
fi
