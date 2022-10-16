# ░░░░░░░ ░░ ░░░░░░  ░░   ░░ ░░   ░░  ░░░░░  ░░░    ░░  ░░░░░░ ░░ ░░░░░░░ ░░  ░░░░░░  ░░░    ░░
# ▒▒      ▒▒ ▒▒   ▒▒ ▒▒  ▒▒  ▒▒   ▒▒ ▒▒   ▒▒ ▒▒▒▒   ▒▒ ▒▒      ▒▒ ▒▒      ▒▒ ▒▒    ▒▒ ▒▒▒▒   ▒▒
# ▒▒▒▒▒▒▒ ▒▒ ▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒  ▒▒ ▒▒      ▒▒ ▒▒▒▒▒▒▒ ▒▒ ▒▒    ▒▒ ▒▒ ▒▒  ▒▒
#      ▓▓ ▓▓ ▓▓   ▓▓ ▓▓  ▓▓  ▓▓   ▓▓ ▓▓   ▓▓ ▓▓  ▓▓ ▓▓ ▓▓      ▓▓      ▓▓ ▓▓ ▓▓    ▓▓ ▓▓  ▓▓ ▓▓
# ███████ ██ ██   ██ ██   ██ ██   ██ ██   ██ ██   ████  ██████ ██ ███████ ██  ██████  ██   ████
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(aliases
rust
colored-man-pages
command-not-found
common-aliases
copybuffer
copypath
dirhistory
fd
git
gitignore
globalias
ripgrep
safe-paste
sudo
systemd
universalarchive
zsh-interactive-cd
zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source /usr/share/doc/pkgfile/command-not-found.zsh
export BAT_THEME="gruvbox-dark"

# Pure prompt
autoload -Uz promptinit
promptinit
prompt pure
zstyle :prompt:pure:prompt:success color white
zstyle :prompt:pure:path color red

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#595959"
# Aliases to not be expanded
GLOBALIAS_FILTER_VALUES=($(cat $ZSH/custom/ignored-aliases.txt))
# Specify which highlighters should be active
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp brackets pattern)
export LANG=pt_BR.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

SUCC="/mnt/succ"

# ALIASES

# aliases for general commands
alias ignored-aliases="$EDITOR $ZSH/custom/ignored-aliases.txt"
alias nvim-edit="$EDITOR $HOME/.config/nvim/init.vim"
alias zshrc="$EDITOR $HOME/.zshrc"
alias zspotify="python $SUCC/Github/zspotify/zspotify/__main__.py"
alias swaycfg="$EDITOR $HOME/.config/sway/config"

# pacman/paru aliases and functions
alias parus="paru -S --useask"
alias paruss="paru -Ss --bottomup"
alias parup="paru && paccache -rk1"

# youtube-dl aliases
alias ytdlp="yt-dlp --cookies $SUCC/cookies.txt --downloader aria2c"
alias ytdlp-mp3="yt-dlp --extract-audio --audio-format mp3"
alias ytdlp-getlink="yt-dlp -g"

# exa aliases
alias e="exa --icons --group-directories-first"
alias exl="exa --icons -lgh --octal-permissions --group-directories-first"
alias exd="exa -a --icons --group-directories-first"

# FUNCTIONS

# use LAME to convert some audio file to MP3
function 2mp3() {
    KBPS=128

    if [[ $# == 0 ]]; then
        echo "Alias to use LAME to convert an audio file to MP3"
        echo "Example: 2mp3 file1 (input) [file 2 (output)] [kbps]"
        return 0
    elif [[ $1 == *".mp3"* ]]; then
        echo "File is already a MP3 file"
        return 1
    elif [[ -n $3 ]]; then
        KBPS=$3
    fi

    lame -b $KBPS $1 $2.mp3
}

# use gcc to compile a .c file
function compc() {
    if [[ $# == 0 ]]; then
        echo "Alias for gcc compiler"
        echo "Example: compc file1.c (input) file2 (output)"
        return 0
    elif [[ $# < 2 ]]; then
        echo "Missing output file"
        return 1
    elif [[ ! $1 == *".c"* ]]; then
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
        echo "Missing output directory"
        return 1
    fi

    curl -Lo /dev/stdout $1 | bsdtar -xf /dev/stdin --directory $2
}

# modified script from https://gist.github.com/kroger/6211862
# uses fluidsynth and lame to convert midi to mp3
function midi2mp3() {
    SOUNDFONT=$SUCC/Downloads/Soundfonts/OmegaGMGS2.sf2
    TMPDIR=.
    KBPS=128

    if [[ ! -f $SOUNDFONT ]]; then
        echo "Couldn't find the soundfont: $SOUNDFONT"
        return 1
    fi

    if [[ $# == 0 ]]; then
        echo "Converts MIDI files to MP3"
        echo "Example: midi2mp3 file1.mid {file2.mid, file3.mid, ...}"
        return 0
    else
        if [[ -n $2 ]]; then
            KBPS=$2
        fi
        for filename in "$@"
        do
            echo "${filename}"
            WAVFILE="$TMPDIR/${filename%.*}"

            fluidsynth -F "${WAVFILE}" $SOUNDFONT "${filename}" && \
            lame -b $KBPS "${WAVFILE}" && \
            rm -f "${WAVFILE}"
        done
    fi
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
    VIDEO_LINK=$(sed -n 1p <<< $LINKS)
    AUDIO_LINK=$(sed -n 2p <<< $LINKS)

    ffmpeg -ss $2 -i $VIDEO_LINK -ss $2 -i $AUDIO_LINK \
        -t $(qalc -t "$3 - $2" to time) -map 0:v -map 1:a -c:v libx264 -c:a aac $4.mkv
}

export PATH="$PATH:$HOME/.local/bin"
unset fd
