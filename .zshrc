# shellcheck disable=all
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
	ripgrep
	rust
	safe-paste
	sudo
	starship
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

# ALIASES

# xbps aliases
# from xtools:
## xi = xbps-install -S
## xrs = xbps-query -Rs
alias xr="sudo xbps-remove -R"
alias xu="sudo xbps-install -Su"

# youtube-dlp aliases
alias ytdlp="yt-dlp --cookies $SUCC/cookies.txt --downloader aria2c"
alias ytdlp-mp3="yt-dlp --extract-audio --audio-format mp3"

# exa aliases
alias e="exa --icons --group-directories-first"
alias el="exa --icons -lgh --octal-permissions --group-directories-first"
alias ed="exa -a --icons --group-directories-first"
alias eld="exa --icons -lgha --octal-permissions --group-directories-first"

zspotify() {
	local ZSPOTIFY_DIR=$SUCC/Github/zspotify

	if [[ ! -d $ZSPOTIFY_DIR ]]; then
		echo "$ZSPOTIFY_DIR does not exist"
		return 1
	fi

	if ! command -v python >/dev/null; then
		echo "python is not installed"
		echo "Tip: xbps-install -S python3"
		return 1
	fi

	pushd $ZSPOTIFY_DIR >/dev/null
	python zspotify.py $1
	if [[ -d "ZSpotify Music" ]]; then
		mkdir --parent "$(xdg-user-dir MUSIC)/ZSpotify Music"
		find "ZSpotify Music" -type f -name "*.mp3" -exec mv {} "$(xdg-user-dir MUSIC)/ZSpotify Music/" \;
		find "ZSpotify Music" -type d -empty -delete
	fi

	popd >/dev/null
}

n() {
	# Block nesting of nnn in subshells
	[ "${NNNLVL:-0}" -eq 0 ] || {
		echo "nnn is already running"
		return
	}

	# The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
	# If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
	# see. To cd on quit only on ^G, remove the "export" and make sure not to
	# use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
	#      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
	export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

	# Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
	# stty start undef
	# stty stop undef
	# stty lwrap undef
	# stty lnext undef

	# The command builtin allows one to alias nnn to n, if desired, without
	# making an infinitely recursive alias
	if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
		tmux new -s nnn "nnn $@"
	fi

	[ ! -f "$NNN_TMPFILE" ] || {
		. "$NNN_TMPFILE"
		rm -f "$NNN_TMPFILE" >/dev/null
	}

	if [ -n "${TMUX}" ]; then
		tmux detach
	fi
}

nnn_cd() {
	if ! [ -z "$NNN_PIPE" ]; then
		printf "%s\0" "0c${PWD}" ! >"${NNN_PIPE}" &
	fi
}

trap nnn_cd EXIT

unset fd
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
