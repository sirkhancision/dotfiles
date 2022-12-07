#!/bin/zsh
# ░░░░░░░ ░░ ░░░░░░  ░░   ░░ ░░   ░░  ░░░░░  ░░░    ░░  ░░░░░░ ░░ ░░░░░░░ ░░  ░░░░░░  ░░░    ░░
# ▒▒      ▒▒ ▒▒   ▒▒ ▒▒  ▒▒  ▒▒   ▒▒ ▒▒   ▒▒ ▒▒▒▒   ▒▒ ▒▒      ▒▒ ▒▒      ▒▒ ▒▒    ▒▒ ▒▒▒▒   ▒▒
# ▒▒▒▒▒▒▒ ▒▒ ▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒  ▒▒ ▒▒      ▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒    ▒▒ ▒▒ ▒▒  ▒▒
#      ▓▓ ▓▓ ▓▓   ▓▓ ▓▓  ▓▓  ▓▓   ▓▓ ▓▓   ▓▓ ▓▓  ▓▓ ▓▓ ▓▓      ▓▓      ▓▓ ▓▓ ▓▓    ▓▓ ▓▓  ▓▓ ▓▓
# ███████ ██ ██   ██ ██   ██ ██   ██ ██   ██ ██   ████  ██████ ██ ███████ ██  ██████  ██   ████
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
	aliases
	colored-man-pages
	common-aliases
	copybuffer
	copypath
	dirhistory
	extract
	fd
	git
	gitignore
	rbw
	ripgrep
	rust
	safe-paste
	sudo
	universalarchive
	zoxide
	zsh-interactive-cd
)

source $ZSH/oh-my-zsh.sh

# Specify which highlighters should be active
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp brackets pattern)

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='hx'
fi

SUCC="/mnt/succ"

# ALIASES

# aliases for general commands
alias zshrc="$EDITOR $HOME/.zshrc"
alias zspotify="python $SUCC/Github/zspotify/zspotify/__main__.py --credentials-location=$HOME"
alias i3cfg="$EDITOR $HOME/.config/i3/config"
alias hxedit="$EDITOR $HOME/.config/helix/config.toml"

# xbps aliases
# from xtools:
## xi = xbps-install -S
## xrs = xbps-query -Rs
alias xr="sudo xbps-remove -R"
alias xu="sudo xbps-install -Su"
alias xuu="$HOME/Github/void-packages/./xbps-src update-sys"

# youtube-dl aliases
alias ytdlp="yt-dlp --cookies $SUCC/cookies.txt --downloader aria2c"
alias ytdlp-mp3="yt-dlp --extract-audio --audio-format mp3"
alias ytdlp-getlink="yt-dlp -g"

# exa aliases
alias e="exa --icons --group-directories-first"
alias el="exa --icons -lgh --octal-permissions --group-directories-first"
alias ed="exa -a --icons --group-directories-first"
alias eld="exa --icons -lgha --octal-permissions --group-directories-first"

# FUNCTIONS

# use gcc to compile a .c file
function compc() {
	if [[ $# == 0 ]]; then
		echo "Alias for gcc compiler"
		echo "Example: compc file1.c (input) file2 (output)"
		return 0
	elif [[ $# < 2 ]]; then
		echo "Missing output file"
		return 1
	elif [[ $1 != *".c"* ]]; then
		echo "Input file $1 is not a .c file"
		return 2
	fi

	gcc -o $2 $1 -march=native -O2 -pedantic -pipe -Wall -Werror -lm -lgmp
}

# use curl and bsdtar to download and extract a compressed archive
function curltar() {
	if [[ $# == 0 ]]; then
		echo "Alias to use curl and bsdtar to download and extract a compressed archive"
		echo "Example: curltar (url) (output-directory)"
		return 0
	elif [[ $# < 2 ]]; then
		DIR=$PWD
	else
		DIR=$2
	fi

	curl -Lo /dev/stdout $1 | bsdtar -xf /dev/stdin --directory $DIR
}

# l1 and l2 are variables that use the command "sed"
# in order to get the video and audio links generated by
# "ytdl-getlink", differentiating them by the line they're in,
# then, it uses ffmpeg to actually download the video, with the
# "-t" argument using a time calculation with "qalc" in order to
# stop exactly where you want in the video
function ytmkvcrop() {
	if [[ $# == 0 ]]; then
		echo "Alias to use ffmpeg and youtube-dl to download only a specific portion of\n\
a video, producing a .mkv video file\n\
Example: ytmkvcrop (video link) (video starting point i.e 00:00) (video\n\
ending point i.e 15:00) filename"
		return 0
	elif [[ -z $4 ]] && [[ $# -ne 4 ]]; then
		echo "Missing output file name"
		return 1
	fi

	LINKS=$(ytdlp-getlink $1)
	VIDEO_LINK=$(sed -n 1p <<<$LINKS)
	AUDIO_LINK=$(sed -n 2p <<<$LINKS)

	ffmpeg -ss $2 -i $VIDEO_LINK -ss $2 -i $AUDIO_LINK \
		-t $(qalc -t "$3 - $2" to time) -map 0:v -map 1:a -c:v libx264 -c:a aac $4.mkv
}

unset fd
eval "$(starship init zsh)"
eval "$(thefuck --alias)"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
