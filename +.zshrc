export TERM="xterm-256color"
export ZSH="$HOME/.oh-my-zsh"

#DISABLE_MAGIC_FUNCTIONS=true

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
#HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
#DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
#HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git archlinux colored-man-pages colorize history)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export LC_ALL=en_GB.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='micro'

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

setopt appendhistory

source "$HOME/antigen.zsh"

up(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}

# Load the oh-my-zsh's library.
antigen use oh-my-zsh
antigen bundle git
antigen bundle archlinux
antigen bundle colored-man-pages
antigen bundle colorize
antigen bundle history
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle MichaelAquilina/zsh-you-should-use

type exa &> /dev/null &&
    antigen bundle DarrinTisdale/zsh-aliases-exa

# ===================== Alias ===================== 
alias help="bat /home/max/.zshrc | grep 'alias ' | grep -v '#alias'"

# File & directories
alias l="eza -G -a --color=auto"
alias lsd="eza -G -a --color=auto -l"
alias lsh="eza -G -a --color=auto --hyperlink -l"
alias ls.="ls -d *.* --color=auto"
alias cat="bat"
alias cat_help="cat /home/max/.zshrc"
alias ls="exa"
alias ext="extract"
alias mkdirs="mkdir -pv"
alias text="sudo gnome-text-editor"
alias count="find . -type f | wc -l"
alias rd="rm -rf"
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias 7z="/mnt/data/LINUX_APPS/7z/7zz"
alias diff="diff -Naur"
alias tar="tar -cvf"
alias untar="tar -xvf"
alias video="/mnt/data/LINUX_APPS/ffmpeg/bash-video/bash-video.sh" # https://github.com/allen-munsch/bash-video
# Available operations:
#  splice <start_time> <end_time> <output_file> - Cut a video segment
#  join <file1> <file2> <output_file> - Join multiple videos
#  speedup <speed_factor> <output_file> - Change playback speed
#  optimize <output_file> - Optimize video to reduce size
#  popleft <duration> <output_file> - Remove a segment from the beginning of the video
#  popright <duration> <output_file> - Remove a segment from the end of the video
#  trim <start_time> <end_time> <output_file> - Trim video by start and end times
#  extractaudio <output_file> - Extract audio from video
#  addaudio <audio_file> <output_file> - Add audio to video
#  resize <width> <height> <output_file> - Resize video
#  rotate <rotation> <output_file> - Rotate video (90, 180, 270)
#  record <output_file> <duration> - Record screen
#  addsubtitle <subtitle_file> <output_file> - Add subtitle to video
#  filter <filter_name> <output_file> - Apply video filter
#  overlay <image_file> <position> <output_file> - Overlay image on video
#  thumbnail <output_file> <timestamp> - Generate video thumbnail

# Network
alias yt="xsel | yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' -o '/home/max/Загрузки/%(title)s.%(ext)s' && printf 'Видео успешно скачано! (см. Загрузки)'"
alias ip="curl ipinfo.io/ip"
alias qr="curl -F-=\<- qrenco.de"
alias paste="curl -F file=@- https://0x0.st"
alias spaste="curl -F 'sprunge=<-' http://sprunge.us"
alias repo="git clone"
alias up0="bash /mnt/data/LINUX_APPS/upload.sh" # https://t.me/bashdays/51
alias ports="netstat -tulanp"
alias speedtest="/home/max/.local/bin/speedtest-cli"
#alias w1="wg-quick up wg0"
#alias w0="wg-quick down wg0"
alias nick="/mnt/data/LINUX_APPS/snoop/snoop_cli"

# AI
alias pin="pinokio"
alias jan="/mnt/data/AI/jan-linux.AppImage"
alias lms="/mnt/data/AI/LMStudio.AppImage"
# https://github.com/ramonvc/freegpt-webui
alias gpt="cd /mnt/data/AI/freegpt-webui && venv && python ./run.py"
# Более правильный список пакетов (freegpt-webui) для установки: https://bin.disroot.org/?c0e545e005305e20#GJ3i9oyKY6hcrVnUdT3eqzaTr4No6vryxMLGsV5BynjW

# Tools
alias lib="lddtree" # пакет pax-utils
alias pass="pwgen -s1ynB 20 40"
alias geckodriver="/mnt/trash/firefox_driver/geckodriver"
alias ubuntu="distrobox enter ubuntu-22-04 -- zsh" # distrobox create --image ubuntu:22.04 --name ubuntu-22-04
alias uad="/mnt/data/LINUX_APPS/uad"

# Info
alias os="neofetch"
alias cpu="cpufetch"
alias mesa="inxi -G | grep Mesa"
alias idate="stat / | grep Birth"
alias gnome="gnome-shell --version"
alias mem5="ps auxf | sort -nr -k 4 | head -5"
alias cpu5="ps auxf | sort -nr -k 3 | head -5"
alias rs="sudo dmidecode -t memory | grep Speed"
alias ac="lscpu" # All about CPU
alias wine_os="wine --version"
alias grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"
alias hw="lshw"
alias info="tldr"

# Disks
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias fsi="cat /etc/fstab"
alias p_trash="/mnt/trash/"
alias trash="cd /mnt/trash/"
alias p_data="/mnt/data/"
alias data="cd /mnt/data/"

# Package manager
alias dil="sudo dnf install"
alias del="sudo dnf remove"
alias fil="flatpak install"
alias fel="flatpak remove"
alias fpc="echo '#!/bin/bash'\"\nflatpak install \"$(flatpak list --app --columns=application | xargs echo -n) > install_flatpaks.sh && chmod +x ./install_flatpaks.sh"
alias upd="sudo dnf update rpmfusion-nonfree-release rpmfusion-free-release fedora-repos nobara-repos --refresh && sudo dnf distro-sync --refresh && sudo dnf update --refresh && flatpak update -y"
alias clean="dnf clean all && flatpak uninstall --unused -y && sudo journalctl --vacuum-time=1weeks"
#alias pru="sudo pacman -Qdtq | sudo pacman -Rsn"
#alias prc="sudo pacman -Scc"
alias pi="pip install"
alias pu="pip uninstall"
alias per="pip freeze > requirements.txt"
alias pir="pi -r requirements.txt"

# APT
alias inst="sudo apt install"
alias upg="sudo apt update && sudo apt dist-upgrade"

# Python
alias py="python"
# alias newvenv="python -m venv venv && source ./venv/bin/activate"
# alias venv="source ./venv/bin/activate"
# Anaconda 3
alias newpy="/mnt/data/LINUX_APPS/new_env_anaconda3.sh"
alias pydev="conda activate pydev"
alias newpydev="conda create -n pydev python=3.12 -y"
alias py38="conda activate python38"
alias newpy38="conda create -n python38 python=3.8 -y"
alias py39="conda activate python39"
alias newpy39="conda create -n python39 python=3.9 -y"
alias py310="conda activate python310"
alias newpy310="conda create -n python310 python=3.10 -y"
alias py311="conda activate python311"
alias newpy311="conda create -n python311 python=3.11 -y"
alias py312="conda activate python312"
alias newpy312="conda create -n python312 python=3.12 -y"
alias ce="conda deactivate"
alias pylist="echo Окружения Python: && ls ~/anaconda3/envs && echo Удаление командой \'rm -r ~/anaconda3/envs/\[env\]\'"

# Other
alias uefi="systemctl reboot --firmware-setup"
alias reboot="sudo /sbin/reboot"
alias poweroff="sudo /sbin/poweroff"
alias end="exit"
alias hgrep="history -i | grep"
alias cls="clear"

___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/max/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/max/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/max/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/max/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
antigen theme bira

# Tell Antigen that you're done.
antigen apply
