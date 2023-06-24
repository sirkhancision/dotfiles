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
SESSION="i3"

# set keyboard layout
setxkbmap -model pc105 -layout br,br -variant ,nodeadkeys -option grp:rctrl_toggle
xset r rate 600 25

# fix network problem on laptop
nmcli c down enp3s0 >/dev/null 2>&1

# set wallpaper
feh --bg-fill "$WALLPAPER"

# autostart programs
lxpolkit &
playerctld daemon &
redshift &
picom --daemon &
qbittorrent &

exec dbus-run-session "$SESSION"
