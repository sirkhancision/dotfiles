#!/bin/bash
# ░░░░░░░ ░░ ░░░░░░  ░░   ░░ ░░   ░░  ░░░░░  ░░░    ░░  ░░░░░░ ░░ ░░░░░░░ ░░  ░░░░░░  ░░░    ░░
# ▒▒      ▒▒ ▒▒   ▒▒ ▒▒  ▒▒  ▒▒   ▒▒ ▒▒   ▒▒ ▒▒▒▒   ▒▒ ▒▒      ▒▒ ▒▒      ▒▒ ▒▒    ▒▒ ▒▒▒▒   ▒▒
# ▒▒▒▒▒▒▒ ▒▒ ▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒  ▒▒ ▒▒      ▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒    ▒▒ ▒▒ ▒▒  ▒▒
#      ▓▓ ▓▓ ▓▓   ▓▓ ▓▓  ▓▓  ▓▓   ▓▓ ▓▓   ▓▓ ▓▓  ▓▓ ▓▓ ▓▓      ▓▓      ▓▓ ▓▓ ▓▓    ▓▓ ▓▓  ▓▓ ▓▓
# ███████ ██ ██   ██ ██   ██ ██   ██ ██   ██ ██   ████  ██████ ██ ███████ ██  ██████  ██   ████
# This script is to be executed after having used void-installer, rebooting the system and updating xbps manually
# It is supposed to be modular, if in any case I want to add/remove/edit something in any step

set -e

USING_WIRELESS=false
USING_BLUETOOTH=false

### FUNCTIONS

## ADD REPOS AND CHANGE MIRRORS
add_repos_mirrors() {
	printf "Adding nonfree and multilib repos, also changing mirrors to Chicago (USA)\n\n"

	sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree &&
		sudo mkdir -p /etc/xbps.d &&
		sudo cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d &&
		sudo sed -i 's|https://repo-default.voidlinux.org|https://mirrors.servercentral.com/voidlinux|g' /etc/xbps.d/*-repository-*.conf
}

## INSTALL PACKAGES AND UPDATE SYSTEM
install_packages() {
	printf "Installing packages with xbps and updating the pre-installed packages\n\n"

	PACKAGES="CopyQ \
        ImageMagick \
        Komikku \
        Thunar \
				alacritty \
        alsa-pipewire \
        alsa-plugins \
        alsa-plugins-32bit \
        alsa-plugins-pulseaudio \
        alsa-utils \
        aria2 \
        autotiling \
        bash-language-server \
				bat \
        betterlockscreen \
        black \
        breeze-obsidian-cursor-theme \
        bsdtar \
        btop \
        clang \
        cmark \
        cups \
				curl \
        dbus-elogind \
        diskonaut \
        dosbox \
        dragon \
        dunst \
        ebook-tools \
        elogind \
        exa \
        fd \
        feh \
        file-roller \
        firefox \
				flatpak \
        font-atkinson-hyperlegible-otf \
				font-awesome \
        font-iosevka \
        fontmanager \
        fonts-croscore-ttf \
        freetype \
        fzf \
        gamemode \
        ghostwriter \
				git \
        gitui \
        glow \
        gnome-disk-utility \
        gnome-epub-thumbnailer \
        gnutls \
        gnutls-32bit \
        gst-plugins-bad1 \
        gst-plugins-bad1-32bit \
        gst-plugins-base1 \
        gst-plugins-base1-32bit \
        gst-plugins-good1 \
        gst-plugins-good1-32bit \
        gst-plugins-ugly1 \
        gst-plugins-ugly1-32bit \
        gvfs \
				gvfs-mtp \
				helix \
				hexchat \
        hunspell-en_US \
        hunspell-pt_BR \
        i3-gaps \
        i3ipc-glib \
        i3lock-color \
        jack \
        jq \
        kcharselect \
        kdenlive \
        krita \
        libXcomposite \
        libXinerama \
        libXinerama-32bit \
        libdrm-32bit \
        libgcc-32bit \
        libglapi-32bit \
        libglvnd-32bit \
        libgsf \
        libjpeg-turbo-32bit \
        libmpg123-32bit \
        libopenal \
        libopenal-32bit \
        libpulseaudio \
        libpulseaudio-32bit \
        libreoffice-calc \
				libreoffice-fonts \
				libreoffice-gnome \
				libreoffice-i18n-pt \
				libreoffice-impress \
        libreoffice-math \
        libreoffice-writer \
        libreoffice-xtensions \
        libstdc++-32bit \
        libva-glx \
        libva-glx-32bit \
        libxslt \
        libxslt-32bit \
        lightdm \
        lightdm-gtk3-greeter \
        lutris \
        lxappearance \
        lxsession \
        lynx \
        maim \
        mediainfo \
        meld \
        mesa-dri \
        mesa-dri-32bit \
        mono \
				mpg123 \
				mpv \
				mpv-mpris \
				musescore \
				ncurses \
				neofetch \
        nerd-fonts \
        nnn \
        nomacs \
        noto-fonts-cjk \
        noto-fonts-emoji \
				ntp \
				obs \
        ocl-icd \
        ocl-icd-32bit \
        okular \
        p7zip \
        p7zip-unrar \
        papirus-folders \
        papirus-icon-theme \
        patch \
        pavucontrol \
        picard \
				picom \
        pipewire \
        playerctl \
        pmount \
        pnpm \
        polybar \
        poppler \
        pulseaudio \
        python-yapf \
        python3-lsp-server \
				python3-mccabe \
				python3-pip \
				python3-pycodestyle \
				python3-pyflakes \
        qalculate-gtk \
        qbittorrent \
        qjackctl \
				qpwgraph \
        qt5ct \
        qt6ct \
        quodlibet \
        rclone \
        redshift \
        renameutils \
        retroarch \
        ripgrep \
        rofi \
        rsync \
        rust-analyzer \
        rustup \
        samba \
        sd \
        shellcheck \
        shfmt \
				skim \
        snooze \
        starship \
        steam \
        sxiv \
				syncplay \
        taplo \
        tealdeer \
        telegram-desktop \
        tg_owt \
        thunar-archive-plugin \
        thunar-media-tags-plugin \
        thunderbird \
        tumbler \
				uni \
        v4l-utils \
        v4l-utils-32bit \
        vim \
        vlc \
        vulkan-loader \
        vulkan-loader-32bit \
        webp-pixbuf-loader \
        wget \
        wine \
        wine-gecko \
        wine-mono \
        winetricks \
        wireplumber \
        xclip \
        xdg-user-dirs \
        xdotool \
        xorg \
        xorg-server-xephyr \
        xss-lock \
        xtools \
        yad \
        yt-dlp \
        zoxide \
        zsh \
        zsh-syntax-highlighting"

	echo "Which brand is your GPU?"
	printf "[1] Nvidia\n[2] AMD\n[3] Intel\n"
	read -r PROMPT
	case $PROMPT in
	"1") GPU="nv-codec-headers nvidia-dkms nvidia-gtklibs-32bit nvidia-libs-32bit" ;;
	"2") GPU="linux-firmware-amd mesa-vulkan-radeon amdvlk mesa-vaapi mesa-vdpau" ;;
	"3") GPU="linux-firmware-intel mesa-vulkan-intel intel-video-accel" ;;
	*) GPU="" ;;
	esac

	echo "Do you use a wireless connection? <y/n>"
	read -r PROMPT
	case $PROMPT in
	"y" | "Y" | "yes" | "Yes")
		WIRELESS="broadcom-wl-dkms NetworkManager"
		USING_WIRELESS=true
		;;
	*) WIRELESS="" ;;
	esac

	echo "Do you use Bluetooth in this device? <y/n>"
	read -r PROMPT
	case $PROMPT in
	"y" | "Y" | "yes" | "Yes")
		BLUETOOTH="bluez bluez-alsa libspa-bluetooth broadcom-bt-firmware"
		USING_BLUETOOTH=true
		;;
	*) BLUETOOTH="" ;;
	esac

	# shellcheck disable=2086
	# this is by design so that the packages are one after the other
	sudo xbps-install -Su $PACKAGES $GPU $WIRELESS $BLUETOOTH
	tldr --update
}

## CREATE DIRECTORIES INSIDE THE USER'S DIRECTORY, AND SET SOME DEFAULT APPS
create_home_dirs() {
	printf "Creating the XDG directories inside the user's home directory,\n"
	printf "also setting default applications\n\n"

	xdg-user-dirs-update
	xdg-mime default nomacs.desktop image
	xdg-mime default thunar.desktop inode/directory
}

## ENABLE SERVICES
runit_services() {
	printf "Enabling services\n\n"

	# enable services
	sudo ln -sf /etc/sv/{elogind,dbus,ntpd,sddm} /var/service

	if [ $USING_WIRELESS == true ]; then
		sudo ln -sf /etc/sv/NetworkManager /var/service
	fi

	if [ $USING_BLUETOOTH == true ]; then
		sudo ln -sf /etc/sv/bluetoothd /var/service
	fi

	sudo ln -sf /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
}

## ADDS FLATHUB REMOTE
add_flathub() {
	printf "Adding flathub as a flatpak remote\n"

	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

## CHANGE PAPIRUS' FOLDERS COLORS
change_folders_colors() {
	printf "Changing folder colors to black (for Papirus icon theme)\n\n"

	papirus-folders -C black
}

## UPDATE WINETRICKS
update_winetricks() {
	printf "Updating winetricks\n\n"

	sudo winetricks --self-update
}

## INSTALL STUFF WITH NPM
install_npm() {
	PACKAGES=(
		vscode-langservers-extracted
	)
	printf "Updating npm and installing the following npm packages:\n"
	echo "${PACKAGES[*]}"

	sudo npm i -g npm "${PACKAGES[*]}"
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

	mkdir "$HOME/Github" &&
		git clone https://github.com/sirkhancision/void-packages.git "$HOME/Github/void-packages"
	cd "$HOME/Github/void-packages"

	if git remote | grep -q upstream; then
		git remote add upstream https://github.com/void-linux/void-packages.git
	fi

	git pull --rebase upstream master &&
		./xbps-src binary-bootstrap &&
		echo XBPS_ALLOW_RESTRICTED=yes >>etc/conf &&
		for PACKAGE in "${PACKAGES[@]}"; do
			./xbps-src pkg "$PACKAGE"
		done &&
		xi "${PACKAGES[*]}"
	cd "$HOME"
}

## DOWNLOAD AND COPY DOTFILES
dotfiles() {
	printf "Cloning the git repo with my dotfiles and running the dotfiles manager\n\n"

	git clone "https://github.com/sirkhancision/dotfiles.git" "$HOME"
	cd dotfiles && ./dotman
}

## INSTALL OH-MY-ZSH
oh_my_zsh() {
	printf "Installing oh-my-zsh\n\n"

	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

disable_bitmap() {
	printf "Disabling bitmap fonts\n\n"
	sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/70-no-bitmaps.conf
}

add_lock_screen() {
	printf "Adding lock screen\n\n"
	betterlockscreen -u "$HOME/dotfiles/lain-white-lock.png"
}

# read arguments/flags
while getopts ":hmpHsfcbwngdz" OPT; do
	case $OPT in
	h)
		printf "void_install: script to install and configure stuff in my system\n\n"
		echo "-h: prints help text"
		echo "-m: adds repository mirrors"
		echo "-p: installs listed packages"
		echo "-H: creates XDG home directories"
		echo "-s: enables runit services"
		echo "-f: adds flathub as a flatpak remote"
		echo "-c: changes papirus folders colors"
		echo "-b: disables bitmap fonts"
		echo "-w: updates winetricks"
		echo "-n: installs listed npm packages"
		echo "-g: clones void-packages and installs its listed packages"
		echo "-d: clones my dotfiles and executes dotman"
		echo "-z: installs oh-my-zsh"
		exit 0
		;;
	m) add_repos_mirrors && exit 0 ;;
	p) install_packages && exit 0 ;;
	H) create_home_dirs && exit 0 ;;
	s) runit_services && exit 0 ;;
	f) add_flathub && exit 0 ;;
	c) change_folders_colors && exit 0 ;;
	b) disable_bitmap && exit 0 ;;
	w) update_winetricks && exit 0 ;;
	n) install_npm && exit 0 ;;
	g) void_packages_git && exit 0 ;;
	d) dotfiles && exit 0 ;;
	z) oh_my_zsh && exit 0 ;;
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

### POST-INSTALL COMMANDS

create_home_dirs
runit_services
add_flathub
change_folders_colors
disable_bitmap
update_winetricks
install_npm
rustup-init
void_packages_git
dotfiles
add_lock_screen
oh_my_zsh

echo "Installation complete! :)"
