#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Power Menu

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt="$(hostname)"
mesg="Uptime : $(uptime -p | sed -e 's/up //g')"

if [[ ($theme == *'type-1'*) || ($theme == *'type-3'*) || ($theme == *'type-5'*) ]]; then
	list_col='1'
	list_row='4'
elif [[ ($theme == *'type-2'*) || ($theme == *'type-4'*) ]]; then
	list_col='4'
	list_row='1'
fi

# Options
layout=$(grep <"${theme}" 'USE_ICON' | cut -d'=' -f2)
if [[ $layout == 'NO' ]]; then
	option_1=" Deslogar"
	option_2="󰤄 Hibernar"
	option_3=" Reiniciar"
	option_4="󰐥 Desligar"
	yes='󰄬 Sim'
	no=' Não'
else
	option_1=""
	option_2="󰤄"
	option_3=""
	option_4="󰐥"
	yes='󰄬'
	no=''
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme "${theme}"
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {orientation: vertical; children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Tem certeza?' \
		-theme "${theme}"
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Confirm and execute
confirm_run() {
	selected="$(confirm_exit)"
	if [[ $selected == "$yes" ]]; then
		${1} && ${2} && ${3}
	else
		exit
	fi
}

# Execute Command
run_cmd() {
	if [[ $1 == "--opt1" ]]; then
		confirm_run "loginctl terminate-user $USER"
	elif [[ $1 == "--opt2" ]]; then
		confirm_run "loginctl hibernate"
	elif [[ $1 == "--opt3" ]]; then
		confirm_run "loginctl reboot"
	elif [[ $1 == "--opt4" ]]; then
		confirm_run "loginctl poweroff"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
"$option_1")
	run_cmd --opt1
	;;
"$option_2")
	run_cmd --opt2
	;;
"$option_3")
	run_cmd --opt3
	;;
"$option_4")
	run_cmd --opt4
	;;
esac
