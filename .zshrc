# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/bruh/.oh-my-zsh"

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
plugins=(git
catimg
safe-paste
common-aliases
zsh-interactive-cd
rand-quote
zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# Bat configs

export BAT_THEME="Solarized (dark)"
export BAT_PAGER=""

# Pure theme

autoload -U promptinit; promptinit
prompt pure

PURE_CMD_MAX_EXEC_TIME=1

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='kate'

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

# SIMPLE ALIASES

# pacman aliases
alias pac="sudo pacman -S"
alias pacrm="sudo pacman -R"
alias pacinfo="pacman -Qi"
alias pacup="sudo pacman -Syu"
alias paclean="paccache -rk1"

# powerpill aliases
alias pill="sudo powerpill -S"
alias pillup="sudo powerpill -Syu"

# youtube-dl aliases
alias ytdl="youtube-dl --cookies /run/media/bruh/succ/cookies.txt"
alias ytdl-mp3="youtube-dl --cookies /run/media/bruh/succ/cookies.txt --extract-audio --audio-format mp3"
alias ytdl-getlink="youtube-dl --cookies /run/media/bruh/succ/cookies.txt --youtube-skip-dash-manifest -g"

# aliases for general commands
alias cl="clear"
alias reload="source ~/.zshrc"

# command listing aliases
alias al-l="tail -n +109 ~/.zshrc | bat -l bash"
alias un-l="bat -l bash /run/media/bruh/succ/Linux/unixcmd_list.lexp"
alias zsh-l="bat -l bash /run/media/bruh/succ/Linux/ohmyzsh_list.lexp"

# personal programs aliases
alias fw="python ~/succ/Programas_aleatorios/Python/fullwidth.py"
alias rs="/run/media/bruh/succ/Programas_aleatorios/C/ram_speed"
alias rc="/run/media/bruh/succ/Programas_aleatorios/C/randomcase"
alias fs="/run/media/bruh/succ/Programas_aleatorios/C/fracsimp"
alias mdc="/run/media/bruh/succ/Programas_aleatorios/C/mdc"

# FUNCTION ALIASES

# use gcc to compile a .c file
compc() {
    if [[ $# == 0 ]]; then
        echo "Alias for gcc compiler"
        echo "Example: compc file1.c (input) file2 (output)"
        return 0
    elif [[ ! $1 == *".c"* ]]; then
        echo "Input file $1 is not a valid .c file"
        return 1
    fi
    
	gcc -O2 -o $2 $1 -ansi -Wall -pedantic -lm
}

# use LAME to convert some audio file to MP3
2mp3() {
    kbps=128
    
    if [[ $# == 0 ]]; then
        echo "Alias to use LAME to convert an audio file to MP3"
        echo "Example: 2mp3 file1 (input) [file 2 (output)] [kbps]"
        return 0
    elif [[ -n $3 ]]; then
        kbps=$3
    fi
    
	lame -b $kbps $1 $2.mp3
	
	if [[ $(ls | grep .mp3.mp3) ]]; then
        rename .mp3.mp3 .mp3 *.mp3.mp3
    fi
    
	cl
}

# modified script from https://gist.github.com/kroger/6211862
# uses fluidsynth and lame to convert midi to mp3
midi2mp3() {
    SOUNDFONT=/run/media/bruh/succ/Downloads/Soundfonts/OmegaGMGS2.sf2
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
    
    cl
}

# flash some connected removable drive with an iso
flash() {
    if [[ $# == 0 ]]; then
        echo "Flashes a bootable removable device with an iso file"
        echo "Example: flash (iso file) (device path)"
        return 0
    fi
    
	sudo dd bs=4M if=$1 of=$2 status=progress oflag=sync
}

# l1 and l2 are variables that use the command "sed"
# in order to get the video and audio links generated by
# "ytdl-getlink", differentiating them by the line they're in,
# then, it uses ffmpeg to actually download the video, with the
# "-t" argument using a time calculation with "qalc" in order to
# stop exactly where you want in the video
ytmkvcrop() {
    if [[ $# == 0 ]]; then
        echo "Alias to use ffmpeg and youtube-dl to download only a specific portion of a video, producing a .mkv video file"
        echo "Example: ytmkvcrop (video link) (video starting point i.e 00:00) (video ending point i.e 15:00) filename"
        return 0
        
    elif [[ -z $4 ]] && [[ $# -ne 4 ]]; then
        echo "Missing output file name"
        return 1
    fi
    
    l1=$(ytdl-getlink $1 | sed -n 1p)
    l2=$(ytdl-getlink $1 | sed -n 2p)
    
    ffmpeg -ss $2 -i $l1 -ss $2 -i $l2 -t $(qalc -t $3 - $2 to time) -map 0:v -map 1:a -c:v libx264 -c:a aac $4.mkv
}
