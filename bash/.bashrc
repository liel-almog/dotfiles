# .bashrc

# Set colored terminal prompt as "hostname:current directory$ "
# Not sure if this works on centos yet
# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

# Niceities
alias cd..="cd .."
alias files="xdg-open"
alias rm="rm -i"  # Interactive mode delete
alias hs="cd ~/ && ls"
alias up="cd .."
alias home="cd ~/"
alias root="sudo su"
alias mkdir="mkdir -pv"  # Creates parent directories if needed
alias hist="history"
alias jobs="jobs -l"
alias path="echo -e ${PATH//:/\\n}"

# Power commands
alias shutdown="sudo shutdown -P now"
alias reboot="sudo shutdown -r now"

# Grep shorthands
alias grep="grep --color=auto"  # Colorize grep command output

# ls shorthands
alias l.="ls -d .* --color=auto"
alias ls="ls -C --color=auto"  # Make 'normal' ls nice with Columns and Colors
alias lm="ls -lhA --color=auto | more"  # For big directories
alias ll="ls -lh --color=auto"
alias la="ls -lhA --color=auto"
alias lar="ls -lhAR --color=auto | more"  # Recursive subdirectories, listed out
alias lcr="ls -CAR --color=auto | more"  # Recursive subdirectories, by column

# Time
alias now="date +"%T""
alias nowtime=now
alias nowdate="date +\"%d-%m-%Y\""

# Networking
alias ports="netstat -tulanp"

# Updates
alias update="dnf -y check-update && sudo dnf -y upgrade"

# File Creation
alias mkfile='function _mkfile(){ mkdir -p "$(dirname "$1")" && touch "$1"; }; _mkfile'

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH

export PATH=$PATH:/usr/local/go/bin

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"


export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

PATH=~/.console-ninja/.bin:$PATH