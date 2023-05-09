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

### FUNCTIONS

## ADD REPOS AND CHANGE MIRRORS
add_repos_mirrors() {
	printf "[1/12] Adding nonfree and multilib repos, also changing mirrors to Chicago (USA)\n\n"
	sleep 3

	sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree &&
		sudo mkdir -p /etc/xbps.d &&
		sudo cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d &&
		sudo sed -i 's|https://repo-default.voidlinux.org|https://mirrors.servercentral.com/voidlinux|g' /etc/xbps.d/*-repository-*.conf
}

## INSTALL PACKAGES AND UPDATE SYSTEM
install_packages() {
	printf "[2/12] Installing packages with xbps and updating the pre-installed packages\n\n"
	sleep 3

	PACKAGES="CopyQ \
        ImageMagick \
        Komikku \
        Thunar \
        alsa-pipewire \
        alsa-plugins \
        alsa-plugins-32bit \
        alsa-plugins-pulseaudio \
        alsa-utils \
        aria2 \
        autotiling \
        bat \
        betterlockscreen \
        black \
        breeze-obsidian-cursor-theme \
        bsdtar \
        btop \
        clang \
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
        kitty \
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
        light \
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
        python3-lsp-server \
        python3-pip \
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
        timeshift \
        tumbler \
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
		;;
	*) BLUETOOTH="" ;;
	esac

	sudo xbps-install -Su $PACKAGES $GPU $WIRELESS $BLUETOOTH
	tldr --update
}

## CREATE DIRECTORIES INSIDE THE USER'S DIRECTORY, AND SET SOME DEFAULT APPS
create_home_dirs() {
	printf "[3/12] Creating the XDG directories inside the user's home directory,\n"
	printf "also setting default applications\n\n"
	sleep 3

	xdg-user-dirs-update
	xdg-mime default nomacs.desktop image
	xdg-mime default thunar.desktop inode/directory
}

## ENABLE SERVICES
runit_services() {
	printf "[4/12] Enabling services\n\n"
	sleep 3

	# enable services
	sudo ln -sf /etc/sv/{elogind,dbus,lightdm} /var/service
	if [ $USING_WIRELESS == true ]; then
		sudo ln -sf /etc/sv/NetworkManager /var/service
	fi
	sudo ln -sf /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
}

## ADDS FLATHUB REMOTE
add_flathub() {
	printf "[5/12] Adding flathub as a flatpak remote\n"
	sleep 3

	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

## CHANGE PAPIRUS' FOLDERS COLORS
change_folders_colors() {
	printf "[6/12] Changing folder colors to black (for Papirus icon theme)\n\n"
	sleep 3

	papirus-folders -C black
}

## UPDATE WINETRICKS
update_winetricks() {
	printf "[7/12] Updating winetricks\n\n"
	sleep 3

	sudo winetricks --self-update
}

## INSTALL STUFF WITH NPM
install_npm() {
	PACKAGES=(bash-language-server
		vscode-langservers-extracted
	)
	printf "[8/12] Updating npm and installing the following npm packages:\n"
	echo "${PACKAGES[*]}"
	sleep 3

	sudo npm i -g npm "${PACKAGES[*]}"
}

## EXECUTE RUSTUP
rustup_stuff() {
	printf "[9/12] Executing rustup to install rust stuff\n\n"
	sleep 3

	rustup-init
}

## CLONE THE VOID-PACKAGES REPO
void_packages_git() {
	PACKAGES=(discord
		spotify
		msttcorefonts
	)

	printf "[10/12] Cloning the void-packages git repo, and building and installing the following packages:\n"
	echo "${PACKAGES[*]}"
	print_void_packages
	sleep 3

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
	printf "[11/12] Cloning the git repo with my dotfiles and running the dotfiles manager\n\n"
	sleep 3

	git clone "https://github.com/sirkhancision/dotfiles.git" "$HOME"
	cd dotfiles && ./dotman
}

## INSTALL OH-MY-ZSH
oh_my_zsh() {
	printf "[12/12] Installing oh-my-zsh\n\n"
	sleep 3

	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

### BASIC INSTALL

add_repos_mirrors
install_packages

### POST-INSTALL COMMANDS

create_home_dirs
runit_services
add_flathub
change_folders_colors

# disable bitmap fonts
echo "Disabling bitmap fonts..."
sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/70-no-bitmaps.conf

update_winetricks
install_npm
rustup_stuff
void_packages_git
dotfiles

# add lock screen
betterlockscreen -u "$HOME/dotfiles/lain-white-lock.png"

oh_my_zsh

echo "Installation complete! :)"

exit 0
