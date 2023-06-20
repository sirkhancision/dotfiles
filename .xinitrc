#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		#shellcheck disable=1090
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -e "$HOME/.xprofile" ]; then
	. "$HOME/.xprofile"
fi

WALLPAPER="$HOME/dotfiles/lain-pink-laptop.png"
LOCKER="betterlockscreen -l dim"
SESSION="i3"

# set keyboard layout
setxkbmap -model pc105 -layout br,br -variant ,nodeadkeys -option grp:rctrl_toggle

xset r rate 600 25

# set lock screen
xset s on && xset s 600
xss-lock -- "$LOCKER" &

# set wallpaper
feh --bg-fill "$WALLPAPER"

# autostart programs
# dunst &
copyq &
lxpolkit &
playerctld daemon &
redshift &
picom --daemon &
qbittorrent &

exec dbus-run-session "$SESSION"
