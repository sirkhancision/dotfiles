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

SUCC="/mnt/succ"

# ALIASES

# aliases for general commands
alias dotman="$HOME/dotfiles/./dotman.sh"

# xbps aliases
# from xtools:
## xi = xbps-install -S
## xrs = xbps-query -Rs
alias xr="sudo xbps-remove -R"
alias xu="sudo xbps-install -Su"
xuu() {
	set -e
	PKGS_DIR=$HOME/Github/void-packages
	XBPS_SRC=$PKGS_DIR/./xbps-src

	pushd $PKGS_DIR >/dev/null
	git checkout master --quiet
	git pull --rebase upstream master --quiet

	UPDATES=$($XBPS_SRC show-sys-updates)

	if [[ $UPDATES != '' ]]; then
		echo "The following packages have updates available:"
		echo $UPDATES
		printf "\nNOTE: the packages will be built before being installed\n"

		if read -q "OPTION?Do you want to update them? <y/n> "; then
			printf "\nUpdating bootstrap...\n"
			$XBPS_SRC bootstrap-update
			printf "\nUpdating packages...\n"
			$XBPS_SRC update-sys
		else
			printf "\nUpdates cancelled\n"
		fi
	else
		echo "No updates available"
	fi

	popd >/dev/null
}

# youtube-dlp aliases
alias ytdlp="yt-dlp --cookies $SUCC/cookies.txt --downloader aria2c"
alias ytdlp-mp3="yt-dlp --extract-audio --audio-format mp3"

# exa aliases
alias e="exa --icons --group-directories-first"
alias el="exa --icons -lgh --octal-permissions --group-directories-first"
alias ed="exa -a --icons --group-directories-first"
alias eld="exa --icons -lgha --octal-permissions --group-directories-first"

# use gcc to compile .c files
compc() {
	local OPTIND OPT

	if ! command -v gcc >/dev/null; then
		echo "gcc is not installed"
		echo "Tip: xbps-install -S gcc"
		return 1
	fi

	while getopts ":ho:" OPT; do
		case $OPT in
		h)
			echo "Usage: compc file1.c [file2.c ...] [-o output_file]"
			return 0
			;;
		o) OUTPUT_FILE=$OPTARG ;;
		\?)
			echo "Invalid option: -$OPTARG"
			return 1
			;;
		esac
	done
	shift $((OPTIND - 1))

	local INPUT_FILES=("$@")
	if [[ ${#INPUT_FILES[@]} == 0 ]]; then
		echo "No input files specified"
		return 1
	fi

	for INPUT_FILE in "${INPUT_FILES[@]}"; do
		if [[ ! -f $INPUT_FILE ]]; then
			echo "$INPUT_FILE not found"
			return 1
		elif [[ $INPUT_FILE != *".c" ]]; then
			echo "$INPUT_FILE is not a .c file"
			return 1
		fi
	done

	for INPUT_FILE in "${INPUT_FILES[@]}"; do
		OUTPUT_FILE="${INPUT_FILE%.c}.out"
		gcc -o $OUTPUT_FILE $INPUT_FILE -O2 -pedantic -pipe -Wall -Werror -lm
	done
}

# use curl and bsdtar to download and extract a compressed archive
curltar() {
	local OPTIND OPT URL OUTPUT_DIR

	if ! command -v curl >/dev/null; then
		echo "curl is not installed"
		echo "Tip: xbps-install -S curl"
		return 1
	fi

	if ! command -v bsdtar >/dev/null; then
		echo "bsdtar is not installed"
		echo "Tip: xbps-install -S bsdtar"
		return 1
	fi

	while getopts "hu:o:" OPT; do
		case $OPT in
		h)
			echo "Usage: curltar [-h] [-u URL] [-o OUTPUT_DIR]"
			return 0
			;;
		u) URL=$OPTARG ;;
		o) OUTPUT_DIR=$OPTARG ;;
		\?)
			echo "Invalid option: -$OPTARG"
			return 1
			;;
		esac
	done
	shift $((OPTIND - 1))

	if [[ -z $URL ]]; then
		echo "No URL specified"
		return 1
	fi

	if [[ -z $OUTPUT_DIR ]]; then
		OUTPUT_DIR=$PWD
	fi

	if [[ ! -d $OUTPUT_DIR ]]; then
		echo "Output directory does not exist"
		return 1
	fi

	if [[ ! -w $OUTPUT_DIR ]]; then
		echo "Output directory is not writable"
		return 1
	fi

	curl -Lo /dev/stdout $URL | bsdtar -xf /dev/stdin --directory $OUTPUT_DIR
}

# download and crop a youtube video with ffmpeg and yt-dlp
ytmkvcrop() {
	local OPTIND OPT VIDEO_LINK AUDIO_LINK END_TIME OUTPUT_FILE

	if ! command -v ffmpeg >/dev/null; then
		echo "ffmpeg is not installed"
		echo "Tip: xbps-install -S ffmpeg"
		return 1
	fi

	if ! command -v yt-dlp >/dev/null; then
		echo "yt-dlp is not installed"
		echo "Tip: xbps-install -S yt-dlp"
		return 1
	fi

	if ! command -v sed >/dev/null; then
		echo "sed is not installed"
		echo "Tip: xbps-install -S sed"
		return 1
	fi

	if ! command -v qalc >/dev/null; then
		echo "qalc is not installed"
		echo "Tip: xbps-install -S libqalculate"
		return 1
	fi

	while getopts "hl:o:" OPT; do
		case $OPT in
		h)
			echo "Usage: ytmkvcrop -l (video link) -o (output file name) [-s (start time) -e (end time)]"
			return 0
			;;
		l)
			LINKS=$(yt-dlp -g $1)
			VIDEO_LINK=$(sed -n 1p <<<$LINKS)
			AUDIO_LINK=$(sed -n 2p <<<$LINKS)
			if [[ -z $VIDEO_LINK ]] || [[ -z $AUDIO_LINK ]]; then
				echo "Error: video link is required"
				return 1
			fi
			;;
		o) OUTPUT_FILE=$OPTARG ;;
		\?)
			echo "Invalid option: -$OPTARG"
			return 1
			;;
		esac
	done
	shift $((OPTIND - 1))

	if [[ -z $OUTPUT_FILE ]]; then
		echo "Error: output file name is required"
		return 1
	fi

	if [[ -z $3 ]]; then
		START_TIME=0
		END_TIME=$(qalc -t "$2" to time)
	else
		START_TIME=$(qalc -t "$2" to time)
		END_TIME=$(qalc -t "$3 - $2" to time)
	fi

	if [[ -z $END_TIME ]]; then
		echo "Error: invalid end time for video"
		return 1
	fi

	ffmpeg -ss $START_TIME -i $VIDEO_LINK -ss $START_TIME -i $AUDIO_LINK \
		-t $END_TIME -map 0:v -map 1:a -c:v libx264 -c:a aac $OUTPUT_FILE.mkv
}

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
	command nnn "$@"

	[ ! -f "$NNN_TMPFILE" ] || {
		. "$NNN_TMPFILE"
		rm -f "$NNN_TMPFILE" >/dev/null
	}
}

nnn_cd() {
	if ! [ -z "$NNN_PIPE" ]; then
		printf "%s\0" "0c${PWD}" ! >"${NNN_PIPE}" &
	fi
}

trap nnn_cd EXIT

unset fd
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
