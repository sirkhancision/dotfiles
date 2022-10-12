#!/usr/bin/env zsh

set -e

swaylock -f -c 000000 \
    --clock \
    --effect-blur 2x5 \
    --effect-vignette 0.4:0.9 \
    --fade-in 0.2 \
    --font "sans-serif" \
    --grace 5 \
    --hide-keyboard-layout \
    --indicator \
    --indicator-radius 200 \
    --indicator-thickness 8 \
    --inside-caps-lock-color 00000088 \
    --inside-clear-color 00000088 \
    --inside-color 00000088 \
    --inside-ver-color 00000088 \
    --inside-wrong-color 00000088 \
    --key-hl-color 953272 \
    --line-caps-lock-color 00000000 \
    --line-clear-color 00000000 \
    --line-color 00000000 \
    --line-ver-color 00000000 \
    --line-wrong-color 00000000 \
    --ring-caps-lock-color 832b2b \
    --ring-clear-color 517f56 \
    --ring-color 832b2b \
    --ring-ver-color ce7730 \
    --ring-wrong-color 793b63 \
    --screenshots \
    --separator-color 00000000 \
    --text-caps-lock-color bdc3c7 \
    --text-clear-color bdc3c7 \
    --text-color bdc3c7 \
    --text-ver-color bdc3c7 \
    --text-wrong-color bdc3c7

exit 0
