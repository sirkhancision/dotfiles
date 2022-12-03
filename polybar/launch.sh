#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch top
echo "---" | tee -a /tmp/polybar_top.log /tmp/polybar_bottom.log
polybar top 2>&1 | tee -a /tmp/polybar_top.log &
disown
polybar bottom 2>&1 | tee -a /tmp/polybar_bottom.log &
disown

echo "Bars launched..."
