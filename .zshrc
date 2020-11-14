# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export EDITOR=nvim
export VISUAL=nvim
export TERM=xterm-256color

source $HOME/.config/zsh/antigen.zsh
antigen init ~/.config/zsh/antigenrc

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    pipenv
    command-not-found
    dirhistory
    docker
    git
    git-extras
    history
    last-working-dir
    pip
    python
    ssh-agent
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
####################################

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
#
####################################

#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs virtualenv)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(battery dir vcs)

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"



####################################

export LIBRARY_PATH=$LIBRARY_PATH:/usr/lib/gcc/x86_64-linux-gnu/5.4.0:/usr/lib/x86_64-linux-gnu/ 

export PATH=/home/linuxbrew/.linuxbrew/bin:/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

####################################

alias gs='git status'
function att() {
    tmux attach -t $1
}
function untar () {
    tar -xvf $1;
    rm -r $1;
}
alias cd=cs
alias ..='cd ..'
alias ...='cd ../..'
alias apt-get='sudo apt-get'
alias pinstall= 'pip install'
alias c='clear'
alias gc='git commit'
alias gca='git commit --amend --no-edit'
alias rm='sudo rm -r'
#alias ls='exa --icons --classify'


# If I ever want to put that in a script: https://askubuntu.com/questions/337411/how-to-permanently-assign-a-different-keyboard-layout-to-a-usb-keyboard
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh

function gsync () {
    git stash && git fetch origin && git reset --hard origin/$(git branch | grep \* | cut -d ' ' -f2)
}

function dualmonitor () {
     xrandr --output DP-1 --mode 1920x1080 && \
     xrandr --output eDP-1 --mode 1920x1080 && \
     xrandr --output DP-1 --right-of eDP-1 && \
     i3-msg '[workspace="1"]' move workspace to output DP-1 && \
     i3-msg '[workspace="2"]' move workspace to output DP-1 && \
     i3-msg '[workspace="3"]' move workspace to output DP-1 && \
     i3-msg '[workspace="8"]' move workspace to output eDP-1 && \
     i3-msg '[workspace="9"]' move workspace to output eDP-1 && \
     i3-msg '[workspace="10"]' move workspace to output eDP-1
}

function citrix () {
    mv ~/Downloads/"$(ls -tr ~/Downloads | tail -n 1)" /tmp/citrix.ica && \
        sed 's/HDXoverUDP=Preferred/HDXoverUDP=false/g' /tmp/citrix.ica > /tmp/citrix_fixed.ica && \
        /opt/Citrix/ICAClient/util/nslaunch /tmp/citrix_fixed.ica & 
}

function monomonitor () {
     xrandr --output eDP-1 --mode 1920x1080 && \
     xrandr --output DP-1 --mode 1920x1080 && \
     xrandr --output DP-1 --same-as eDP-1
}

# setxkbmap -layout us -option caps:escape
# setxkbmap -device 10 -layout us -option caps:escape
# setxkbmap -device 11 -layout us -option caps:escape

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
