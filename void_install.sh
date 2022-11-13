#!/bin/bash
# ░░░░░░░ ░░ ░░░░░░  ░░   ░░ ░░   ░░  ░░░░░  ░░░    ░░  ░░░░░░ ░░ ░░░░░░░ ░░  ░░░░░░  ░░░    ░░
# ▒▒      ▒▒ ▒▒   ▒▒ ▒▒  ▒▒  ▒▒   ▒▒ ▒▒   ▒▒ ▒▒▒▒   ▒▒ ▒▒      ▒▒ ▒▒      ▒▒ ▒▒    ▒▒ ▒▒▒▒   ▒▒
# ▒▒▒▒▒▒▒ ▒▒ ▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒  ▒▒ ▒▒      ▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒    ▒▒ ▒▒ ▒▒  ▒▒
#      ▓▓ ▓▓ ▓▓   ▓▓ ▓▓  ▓▓  ▓▓   ▓▓ ▓▓   ▓▓ ▓▓  ▓▓ ▓▓ ▓▓      ▓▓      ▓▓ ▓▓ ▓▓    ▓▓ ▓▓  ▓▓ ▓▓
# ███████ ██ ██   ██ ██   ██ ██   ██ ██   ██ ██   ████  ██████ ██ ███████ ██  ██████  ██   ████
# This script is to be executed after having used void-installer, rebooting the system and updating xbps manually
# It is supposed to be modular, if in any case I want to add/remove/edit something in any step
# It also hasn't been properly tested yet, but oh well :)

set -e

### FUNCTIONS

## ADD REPOS AND CHANGE MIRRORS
function add_repos_mirrors {
	printf "[1/12] Adding nonfree and multilib repos, also changing mirrors to Chicago (USA)\n\n"
	sleep 3

	sudo xbps-install -S "void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree" &&
		sudo mkdir -p /etc/xbps.d &&
		sudo cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d &&
		sudo sed -i 's|https://repo-default.voidlinux.org|mirrors.servercentral.com/voidlinux|g' /etc/xbps.d/*-repository-*.conf
}

## INSTALL PACKAGES AND UPDATE SYSTEM
function install_packages {
	printf "[2/12] Installing packages with xbps and updating the pre-installed packages\n\n"
	sleep 3

	PACKAGES="Thunar \
		Waybar \
		alsa-plugins \
		alsa-plugins-32bit \
		alsa-plugins-pulseaudio \
		aria2 \
		bat \
		bsdtar \
		btop \
		celluloid \
		clang \
		clipman \
		cups \
		curl \
		dbus-elogind \
		diskonaut \
		dosbox \
		dunst \
		ebook-tools \
		elogind \
		exa \
		fd \
		file-roller \
		firefox \
		flatpak \
		font-awesome \
		fontmanager \
		fonts-croscore-ttf \
		freetype \
		fzf \
		gamemode \
		git \
		gitui \
		gnome-disk-utility \
		gnome-epub-thumbnailer \
		gnutls \
		gnutls-32bit \
		grim \
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
		ipafont-fonts-otf \
		jq \
		kcharselect \
		kdenlive \
		kitty \
		krename \
		krita \
		libXinerama \
		libXinerama-32bit \
		libdrm-32bit \
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
		libreoffice-impress \
		libreoffice-math \
		libreoffice-writer \
		libstdc++-32bit \
		libva-glx \
		libva-glx-32bit \
		libxcomposite \
		libxslt \
		libxslt-32bit \
		light \
		linux-firmware-amd \
		lutris \
		lxsession \
		meld \
		mesa-dri \
		mono \
		mpg123 \
		mpv \
		mpv-mpris \
		musescore \
		ncurses \
		neofetch \
		nerd-fonts \
		nomacs \
		noto-fonts-emoji \
		nv-codec-headers \
		nvidia-dkms \
		nvidia-gtklibs-32bit \
		nvidia-libs-32bits \
		obs \
		ocl-icd \
		ocl-icd-32bit \
		okular \
		opencl-icd \
		p7zip \
		p7zip-unrar \
		papirus-folders \
		papirus-icon-theme \
		pavucontrol \
		picard \
		pipewire \
		playerctl \
		pnpm \
		poppler-glib \
		python3-lsp-server \
		qalculate-gtk \
		qbittorrent \
		qpwgraph \
		qt5-wayland \
		qt5ct \
		qt6-wayland \
		qt6ct \
		quodlibet \
		rbw \
		retroarch \
		ripgrep \
		ripgrep \
		rsync \
		rust-analyzer \
		rustup \
		samba \
		sd \
		shellcheck \
		shfmt \
		slurp \
		starship \
		steam \
		sway \
		swaybg \
		swayidle \
		swaylock \
		syncplay \
		taplo \
		tealdeer \
		telegram-desktop \
		thefuck \
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
		webp-pixbug-loader \
		wine \
		wine-gecko \
		wine-mono \
		winetricks \
		wireplumber \
		wl-clipboard \
		wlogout \
		xdg-desktop-portal-wlr \
		xdg-user-dirs \
		xorg-minimal \
		xorg-server-xwayland \
		xtools \
		yt-dlp \
		zoxide \
		zsh \
		zsh-syntax-highlighting"

	sudo xbps-install -Su "$PACKAGES"
}

## CREATE XDG DIRS IN HOME DIR
function create_home_dirs {
	printf "[3/12] Creating the XDG directories inside the user's home directory\n\n"
	sleep 3

	xdg-user-dirs-update
}

## INSTALL OH-MY-ZSH
function oh_my_zsh {
	printf "[4/12] Installing oh-my-zsh\n\n"
	sleep 3

	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

## DOWNLOAD AND COPY DOTFILES
function dotfiles {
	printf "[5/12] Cloning the git repo with my dotfiles and copying the files to where they belong\n\n"
	sleep 3

	mkdir ~/Github && git clone "https://github.com/sirkhancision/dotfiles.git" ~/Github
	mkdir ~/.themes && cp ~/Github/dotfiles/oomox-Eonyze ~/.themes
	cp -r ~/Github/dotfiles/{.zprofile,.zshrc} ~/
	cp -r ~/Github/dotfiles/{dunst,fontconfig,gitui,gtk-3.0,helix,kitty,qt5ct,qt6ct,sway,waybar,wlogout,starship.toml} ~/.config
}

## ENABLE/DISABLE SERVICES
function runit_services {
	printf "[6/12] Enabling services and disabling unnecessary ttys\n\n"
	sleep 3

	# enable services
	sudo ln -s /etc/sv/elogind /var/service
	sudo ln -s /etc/sv/dbus /var/service
	sudo ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
	# remove unnecessary ttys
	sudo rm -rf /var/service/agetty-tty[2-6]
}

## ADDS FLATHUB REMOTE AND INSTALLS FLATPAKS
function install_flatpak {
	function print_flatpaks {
		echo "XIVLauncher"
		echo "Heroic Games Launcher"
		echo "Discord"
		printf "\n"
	}

	printf "[7/12] Adding flathub as a flatpak remote, and installing the following apps:\n"
	print_flatpaks
	sleep 3

	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# installs XIVLauncher, Heroic Games Launcher, Discord
	flatpak install flathub dev.goats.xivlauncher com.heroicgameslauncher.hgl com.discordapp.Discord
}

## CHANGE PAPIRUS' FOLDERS COLORS
function change_folders_colors {
	printf "[8/12] Changing folder colors to black (for Papirus icon theme)\n\n"
	sleep 3

	papirus-folders -C black
}

## UPDATE WINETRICKS
function update_winetricks {
	printf "[9/12] Updating winetricks\n\n"
	sleep 3

	sudo winetricks --self-update
}

## INSTALL STUFF WITH NPM
function install_npm {
	function print_npm_packages {
		echo "bash-language-server"
		echo "vscode-json-languageserver"
		echo "vscode-css-languageserver-bin"
		echo "vscode-html-languageserver-bin"
		printf "\n"
	}
	printf "[10/12] Updating npm and installing the following npm packages:\n"
	print_npm_packages
	sleep 3

	sudo npm i -g npm bash-language-server vscode-json-languageserver vscode-css-languageserver-bin vscode-html-languageserver-bin
}

## EXECUTE RUSTUP
function rustup_stuff {
	printf "[11/12] Executing rustup to install rust stuff\n\n"
	sleep 3

	rustup-init
}

## CLONE THE VOID-PACKAGES REPO
function void_packages_git {
	function print_void_packages {
		echo "spotify"
		echo "msttcorefonts"
		printf "\n"
	}
	printf "[12/12] Cloning the void-packages git repo, and building and installing the following packages:\n"
	print_void_packages
	sleep 3

	mkdir ~/Github && git clone https://github.com/void-linux/void-packages.git ~/Github
	cd ~/Github/void-packages && ./xbps-src pkg spotify msttcorefonts && xi spotify msttcorefonts
	cd ~/
}

### BASIC INSTALL

add_repos_mirrors
install_packages

### POST-INSTALL COMMANDS

create_home_dirs
oh_my_zsh
dotfiles
runit_services
install_flatpak
change_folders_colors
update_winetricks
install_npm
rustup_stuff
void_packages_git

echo "Installation complete! :)"

exit 0
