#!/usr/bin/env zsh

zmodload zsh/regex
set -e

DELAY=0.2

while sleep $DELAY; do
    wp_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    if [[ $wp_output =~ ^Volume:[[:blank:]]([0-9]+)\.([0-9]{2})([[:blank:]].MUTED.)?$ ]]; then
        if [[ -n ${match[3]} ]]; then
            printf "MUTE\n"
        else
            volume=$(( ${match[1]}${match[2]} ))
            if [[ $volume -gt 50 ]]; then
                printf " $volume%%\n"
            elif [[ $volume -gt 25 ]]; then
                printf " $volume%%\n"
            elif [[ $volume -gt 0 ]]; then
                printf " $volume%%\n"
            else
                printf "---\n"
            fi
        fi
    fi
done

exit 0
