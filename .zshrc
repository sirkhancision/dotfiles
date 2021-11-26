# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aliases
cargo
colored-man-pages
copybuffer
copydir
common-aliases
fd
dirhistory
genpass
git
gitignore
globalias
kate
safe-paste
ripgrep
sudo
universalarchive
zsh-autosuggestions
zsh-interactive-cd
zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# Bat configs
export BAT_THEME="gruvbox-dark"

# Pure prompt
autoload -Uz promptinit
promptinit
prompt pure

# zsh-autosuggestions configs
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#595959"

# Aliases to not be expanded
GLOBALIAS_FILTER_VALUES=($(cat $ZSH/custom/ignored-aliases.txt))

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ALIASES
SUCC="/run/media/bruh/succ"

# aliases for general commands
alias asf="/opt/ArchiSteamFarm-bin/./ArchiSteamFarm"
alias zshrc="$EDITOR $HOME/.zshrc"
alias zspotify="python $SUCC/Github/zspotify/zspotify/__main__.py"
alias emby-start="systemctl start emby-server.service"
alias emby-stop="systemctl stop emby-server.service"
alias nvim-edit="$EDITOR $HOME/.config/nvim/init.vim"
alias ignored-aliases="$EDITOR $ZSH/custom/ignored-aliases.txt"

# pacman/paru aliases and functions
alias parus="paru -S --useask"
alias paruss="paru -Ss --bottomup"
alias parup="paru && paru -c && paccache -rk1"

# personal programs aliases
alias fs="$HOME/.local/bin/./fraction_simplifier"
alias fw="$HOME/.local/bin/./fullwidth_converter"
alias mdc="$HOME/.local/bin/./mdc"
alias rc="$HOME/.local/bin/./randomcase"
alias kegel="$HOME/.local/bin/./kegel_routine"

# youtube-dl aliases
alias ytdlp="yt-dlp --cookies $SUCC/cookies.txt --downloader aria2c"
alias ytdlp-mp3="yt-dlp --extract-audio --audio-format mp3"
alias ytdlp-getlink="yt-dlp -g"

# FUNCTION ALIASES

# use LAME to convert some audio file to MP3
function 2mp3() {
    kbps=128

    if [[ $# == 0 ]]; then
        echo "Alias to use LAME to convert an audio file to MP3"
        echo "Example: 2mp3 file1 (input) [file 2 (output)] [kbps]"
        return 0
    elif [[ $1 == *".mp3"* ]]; then
        echo "File is already a MP3 file"
        return 1
    elif [[ -n $3 ]]; then
        kbps=$3
    fi

    lame -b $kbps $1 $2.mp3
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
    kbps=128

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
            kbps=$2
        fi
        for filename in "$@"
        do
            echo "${filename}"
            WAVFILE="$TMPDIR/${filename%.*}"

            fluidsynth -F "${WAVFILE}" $SOUNDFONT "${filename}" && \
            lame -b $kbps "${WAVFILE}" && \
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

    l1=$(ytdlp-getlink $1 | sed -n 1p)
    l2=$(ytdlp-getlink $1 | sed -n 2p)

    ffmpeg -ss $2 -i $l1 -ss $2 -i $l2 -t $(qalc -t "$3 - $2" to time) -map 0:v -map 1:a -c:v libx264 \
        -c:a aac $4.mkv
}

export PATH="$PATH:$HOME/.local/bin"
unset fd
