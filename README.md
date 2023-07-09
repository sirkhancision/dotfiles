# dotfiles

![desktop + dunst + terminal](screenshots/2023-07-01_01-40-57.png)

A set of configuration files for my personal system (Void Linux). See **dotman** to automate much of this process. There's also **void_configure.sh**, to automate things after installing Void Linux.

---

**System's fonts:** 

- _Sans-serif:_ [Atkinson Hyperlegible](https://brailleinstitute.org/freefont)
	- `xbps-install font-atkinson-hyperlegible-otf`
- _Monospaced:_ [Iosevka Fixed](https://github.com/be5invis/Iosevka)
	- `xbps-install font-iosevka`

**Cursor theme:** Breeze Obsidian

`xbps-install breeze-obsidian-cursor-theme`

**.config/foot:** Configuration for the foot terminal.

`xbps-install foot`

**.config/dunst:** Configuration for the Dunst notification manager.

`xbps-install dunst`

**.config/fontconfig/fonts.conf:** Configuration file for system-wide fonts.

**.config/gitui:** Theme configuration for gitui.

`xbps-install gitui`

**.config/gtk-3.0:** Configuration for GTK3 apps.

**.config/helix:** Configuration file for the Helix text editor.

`xbps-install helix`

**.config/nushell:** Configuration file for Nushell.

`xbps-install nushell`

**.config/sway:** Sway's configuration directory.

`xbps-install sway`

**dotman:** Nushell script to manage dotfiles ([here's its readme](https://github.com/sirkhancision/dotfiles/blob/swaywm/DOTMAN_README.md)).

`./dotman`

**.icons:** Configuration to set the cursor theme.

**/boot/grub/themes/lain-glitch-theme:** Theme for GRUB based on Serial Experiments Lain.

**/etc/greetd/config.toml:** Configuration file for greetd, using tuigreet.

`xbps-install greetd tuigreet`

**/etc/doas.conf:** Configuration file for doas.

`xbps-install doas`

**.config/nnn:** Configuration for the file manager nnn.

`xbps-install nnn`

**.config/waybar:** Configuration for waybar.

`xbps-install Waybar`

**lain-pink.png**: Slightly modified wallpaper featuring Lain Iwakura from Serial Experiments Lain. (with variant for laptops)

**lain-white-lock.png**: Slightly modified version of the above wallpaper, for use on the lock screen. (with variant for laptops)

**.themes/oomox-Merionette**: GTK 2/3 themes from Merionette color scheme. Made by me.

**papirus-folders**: Black theme used.

`xbps-install papirus-folders`

**.config/qt5ct && .config/qt6ct:** Themes for QT5 and QT6 applications, using the GTK Eonyze colorscheme along with the Fusion style.

`xbps-install qt5ct qt6ct`

**.config/rofi:** Configured from [adi109x's fork of Rofi](https://github.com/adi1090x/rofi).

`xbps-install rofi`

**.config/starship.toml:** Configuration file for Starship.

`xbps-install starship`

**void_install.sh:** Script to do a lot of post-install stuff on my Void Linux system.

**void_packages:** File to be sourced by void_install.sh, containing packages to be downloaded by it.

**.zshrc:** ZSH's main file with configurations, aliases and functions.

**.profile:** File sourced at login.
