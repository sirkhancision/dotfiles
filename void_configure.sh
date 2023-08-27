#!/bin/bash
# ░░░░░░░ ░░ ░░░░░░  ░░   ░░ ░░   ░░  ░░░░░  ░░░    ░░  ░░░░░░ ░░ ░░░░░░░ ░░  ░░░░░░  ░░░    ░░
# ▒▒      ▒▒ ▒▒   ▒▒ ▒▒  ▒▒  ▒▒   ▒▒ ▒▒   ▒▒ ▒▒▒▒   ▒▒ ▒▒      ▒▒ ▒▒      ▒▒ ▒▒    ▒▒ ▒▒▒▒   ▒▒
# ▒▒▒▒▒▒▒ ▒▒ ▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒  ▒▒ ▒▒      ▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒    ▒▒ ▒▒ ▒▒  ▒▒
#      ▓▓ ▓▓ ▓▓   ▓▓ ▓▓  ▓▓  ▓▓   ▓▓ ▓▓   ▓▓ ▓▓  ▓▓ ▓▓ ▓▓      ▓▓      ▓▓ ▓▓ ▓▓    ▓▓ ▓▓  ▓▓ ▓▓
# ███████ ██ ██   ██ ██   ██ ██   ██ ██   ██ ██   ████  ██████ ██ ███████ ██  ██████  ██   ████
#
# Run this script after using void-installer, rebooting, and manually updating
# xbps. It should be modular in case I want to add/remove/edit something in
# any step.

set -e

### FUNCTIONS

read_prompt() {
	prompt=$1
	options=$2

	echo -en "$prompt <${options^}>: "
	read -r input

	if [[ $options =~ (^|[[:space:]])"$input"($|[[:space:]]) ]]; then
		return 0
	else
		return 1
	fi
}

## ADD REPOS AND CHANGE MIRRORS
add_repos_mirrors() {
	printf "Adding nonfree and multilib repos, also changing mirrors to Chicago (USA)\n\n"

	doas xbps-install -S xmirror void-repo-{nonfree,multilib,multilib-nonfree}
	doas xmirror -s "https://repo-fastly.voidlinux.org/current"
}

## INSTALL PACKAGES AND UPDATE SYSTEM
install_packages() {
	printf "Installing packages with xbps and updating the preinstalled packages\n\n"

	source void_packages

	declare -A gpu_packages=(
		["1"]="nv-codec-headers nvidia-dkms nvidia-gtklibs-32bit nvidia-libs-32bit"
		["2"]="linux-firmware-amd mesa-vulkan-radeon amdvlk mesa-vaapi mesa-vdpau"
		["3"]="linux-firmware-intel mesa-vulkan-intel intel-video-accel"
	)

	declare -A prompt_messages=(
		["gpu"]="What brand is your GPU?\n[1] Nvidia\n[2] AMD\n[3] Intel\n"
		["wireless"]="Do you use a wireless connection?"
		["bluetooth"]="Do you use Bluetooth in this device?"
	)

	declare -A package_lists=(
		["gpu"]="GPU"
		["wireless"]="WIRELESS"
		["bluetooth"]="BLUETOOTH"
	)

	if read_prompt "${prompt_messages[gpu]}" "1 2 3"; then
		if [[ $REPLY =~ ^[1-3]$ ]]; then
			PACKAGES+=" ${gpu_packages[$REPLY]}"
		fi
	fi

	for key in "${!package_lists[@]}"; do
		if [[ $key != "gpu" ]]; then
			if read_prompt "${prompt_messages[$key]}" "y Y n N"; then
				if [[ $REPLY =~ ^[Yy]$ ]]; then
					declare -n package_list="${package_lists[$key]}"
					package_list="${package_list% } ${package_list% }-dkms"
				fi
			fi
		fi
	done

	# shellcheck disable=2086
	# this is by design so that the packages are sequential
	doas xbps-install -Su $PACKAGES
}

set_doas() {
	printf "Setting doas as the root-access command\n\n"
	su -c 'echo "permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :wheel
permit setenv { XAUTHORITY LANG LC_ALL COLORTERM HOME } :wheel" >/etc/doas.conf'
	su -c "chmod -c 0400 /etc/doas.conf"
	su -c 'echo "ignorepkg=sudo" >>/etc/xbps.d/10-ignore.conf'
	su -c "xbps-remove sudo"
}

## CREATE DIRECTORIES IN THE USER'S HOME DIRECTORY AND SET SOME DEFAULT
## APPLICATIONS
create_home_dirs() {
	printf "Creating the XDG directories in the user's home directory,\n"
	printf "also setting default applications\n\n"

	xdg-user-dirs-update
	xdg-mime default nomacs.desktop image
	xdg-mime default thunar.desktop inode/directory
}

## ENABLE SERVICES
runit_services() {
	printf "Enabling services\n\n"

	services=("NetworkManager"
		"bluetoothd"
		"chrony"
		"dbus"
		"greetd"
		"thermald"
	)

	for service in "${services[@]}"; do
		if [ ! -d "/etc/sv/$service" ]; then
			echo "/etc/sv/$service not found, ignoring"
			continue
		fi

		doas ln -sf "/etc/sv/$service" /var/service
	done

	doas ln -sf /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
}

## ADDS FLATHUB REMOTE
add_flathub() {
	printf "Adding Flathub as a flatpak remote\n\n"

	doas flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

## CHANGE PAPIRUS' FOLDERS COLORS
change_folders_colors() {
	printf "Changing folder colors to black (for Papirus icon theme)\n\n"

	papirus-folders -C black
}

## UPDATE WINETRICKS
update_winetricks() {
	printf "Updating winetricks\n\n"

	doas winetricks --self-update
}

## INSTALL STUFF WITH NPM
npm_install() {
	PACKAGES=(
		vscode-langservers-extracted
	)
	printf "Updating npm and installing the following npm packages:\n"
	echo "${PACKAGES[*]}"

	doas npm i -g npm "${PACKAGES[*]}"
}

## CLONE THE VOID-PACKAGES REPO
void_packages_git() {
	PACKAGES=(discord
		spotify
		msttcorefonts
	)

	printf "Cloning the void-packages git repo, and building and installing the following packages:\n"
	echo "${PACKAGES[*]}"
	print_void_packages

	mkdir "$HOME/Github"

	if ! git clone https://github.com/sirkhancision/void-packages.git "$HOME/void-packages"; then
		echo "Failed to clone the repository."
		return 1
	fi

	cd "$HOME/void-packages" || return 1

	if ! git remote | grep -q upstream; then
		git remote add upstream https://github.com/void-linux/void-packages.git
	fi

	git pull --rebase upstream master

	./xbps-src binary-bootstrap
	echo XBPS_ALLOW_RESTRICTED=yes >>etc/conf
	echo XBPS_CHECK_PKGS=yes >>etc/conf

	for PACKAGE in "${PACKAGES[@]}"; do
		./xbps-src pkg "$PACKAGE"
	done

	xi "${PACKAGES[*]}"
	cd "$HOME"
}

## DOWNLOAD AND COPY DOTFILES
dotfiles() {
	printf "Cloning the git repo with my dotfiles and running the dotfiles manager\n\n"

	git clone "https://github.com/sirkhancision/dotfiles.git" "$HOME"
	cd dotfiles && ./dotman
}

disable_bitmap() {
	printf "Disabling bitmap fonts\n\n"
	doas ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/70-no-bitmaps.conf
}

enable_light() {
	printf "Enabling the light backlight controller\n\n"
	mkdir -p /etc/udev/rules.d
	doas echo "SUBSYSTEM==\"backlight\", ACTION==\"add\", \
  RUN+=\"/bin/chgrp video /sys/class/backlight/%k/brightness\", \
  RUN+=\"/bin/chmod g+w /sys/class/backlight/%k/brightness\"" >/etc/udev/rules.d/90-backlight.rules
	doas usermod --append --groups video "$(whoami)"
}

# read arguments/flags
while getopts ":hmpDHsfcbwngdl" OPT; do
	case $OPT in
	h)
		printf "void_configure: script to install and configure stuff on my system\n\n"
		printf "[USAGE] ./void_configure.sh [-h|m|p|H|s|f|c|b|w|n|g|d|l]\n\n"
		echo "-h: print help text"
		echo "-m: add repository mirrors"
		echo "-p: install listed packages"
		echo "-D: set doas as the root-access command"
		echo "-H: create XDG home directories"
		echo "-s: enable runit services"
		echo "-f: add flathub as a flatpak remote"
		echo "-c: change colors of papirus folders"
		echo "-b: disable bitmap fonts"
		echo "-w: update winetricks"
		echo "-n: install listed npm packages"
		echo "-g: clone void-packages and install listed packages"
		echo "-d: clone my dotfiles and run dotman"
		echo "-l: enable backlight controlling"
		exit 0
		;;
	m) add_repos_mirrors && exit 0 ;;
	p) install_packages && exit 0 ;;
	D) set_doas && exit 0 ;;
	H) create_home_dirs && exit 0 ;;
	s) runit_services && exit 0 ;;
	f) add_flathub && exit 0 ;;
	c) change_folders_colors && exit 0 ;;
	b) disable_bitmap && exit 0 ;;
	w) update_winetricks && exit 0 ;;
	n) npm_install && exit 0 ;;
	g) void_packages_git && exit 0 ;;
	d) dotfiles && exit 0 ;;
	l) enable_light && exit 0 ;;
	\?)
		echo "Invalid option: -$OPTARG"
		return 1
		;;
	esac
done
shift $((OPTIND - 1))

### BASIC INSTALL

add_repos_mirrors
install_packages
set_doas
tldr --update

### POST-INSTALL COMMANDS

create_home_dirs
runit_services
add_flathub
change_folders_colors
disable_bitmap
update_winetricks
npm_install
rustup-init
void_packages_git
dotfiles
enable_light

echo "Installation complete! :)"
