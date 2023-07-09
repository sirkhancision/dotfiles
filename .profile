. "$HOME/.cargo/env"

# default text editor
export EDITOR="hx"
# alternate hard disk
export SUCC="/mnt/succ"
# qt5 theme tool
export QT_QPA_PLATFORMTHEME=qt5ct
# bat theme
export BAT_THEME="base16"
# add /home/.local/bin to path
export PATH="$PATH:$HOME/.local/bin"
# default terminal
export TERM=foot
# default terminal for nnn
export NNN_TERMINAL=$TERM
# nnn options
export NNN_OPTS="r"
# nnn fifo
export NNN_FIFO=/tmp/nnn.fifo
# nnn colors
export NNN_COLORS='3333'
BLK="0C" CHR="05" DIR="01" EXE="02" REG="00" HARDLINK="04" SYMLINK="0E" MISSING="08" ORPHAN="09" FIFO="07" SOCK="0D" OTHER="0F"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
# nnn bookmarks
export NNN_BMS="D:$HOME/Downloads;d:$HOME/Documentos;g:$HOME/Github;i:$HOME/Imagens;m:$HOME/Músicas;V:$HOME/void-packages;v:$HOME/Vídeos;.:$HOME/dotfiles"
# nnn plugins
export NNN_PLUG='D:dups;F:fixname;G:getplugs;I:imgur;M:mtpmount;O:organize;X:xdgdefault;d:dragdrop;f:finder;i:imgview;m:nmount;o:xdgopen;p:preview-tui;r:renamer;s:suedit;x:togglex;z:autojump'
# exa colors
export EXA_COLORS="di=1;31"
# run firefox in wayland
export MOZ_ENABLE_WAYLAND=1

# fix network problem on laptop
nmcli c down enp3s0 >/dev/null 2>&1
