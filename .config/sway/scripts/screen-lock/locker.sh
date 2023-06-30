#!/bin/sh

SWAY_SCRIPTS_DIR="$HOME/.config/sway/scripts"
LOCK_CMD="swaylock --config $SWAY_SCRIPTS_DIR/screen-lock/swaylock_config"
POWER_OFF_CMD='swaymsg "output * power off"'
POWER_ON_CMD='swaymsg "output * power on"'

if [ $# = 1 ]; then
	if [ "$1" = "timeout" ]; then
		timout 600 "$LOCK_CMD"
		timout 720 "$POWER_OFF_CMD"
		resume "$POWER_ON_CMD"
	elif [ "$1" = "instant" ]; then
		$LOCK_CMD
		timeout 120 "$POWER_OFF_CMD"
		resume "$POWER_ON_CMD"
	fi
else
	echo "Missing argument"
fi
